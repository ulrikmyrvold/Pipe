$deployPackagePath = "..\DeployPackage\"
$MsBuild = $env:systemroot + "\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe";
$ProjectFilePath = "..\Pipe.Web\Pipe.Web.csproj"
$Configuration = "Release"
$BuildWebDeployPackageLog ="..\build_webDeployPackage.log"
$webdeployPackagePath = $deployPackagePath + "\Content\"
$webdeployPackageFile = $webdeployPackagePath + "Pipe.Web.zip"
$webtestDeployPackagePath = $deployPackagePath + "WebTest\"


$BuildWebDeployPackageArgs = @{
 FilePath = $MsBuild
 ArgumentList = $ProjectFilePath, "/t:package", ("/p:Configuration=" + $Configuration+ ";PackageLocation=" + $webdeployPackageFile), "/v:minimal"
 RedirectStandardOutput = $BuildWebDeployPackageLog
 #NoNewWindow = $true
 Wait = $true
 PassThru = $true
 }
 
function CleanDirectory(){
	if(Test-Path $deployPackagePath){
		Remove-Item -Path $deployPackagePath"*" -Recurse -Force
	}
} 
 
function CreateWebDeployPackage(){
	Write-Host "building web deploy package"
	$Build = Start-Process @BuildWebDeployPackageArgs
	Write-Host (Get-Content -Path $BuildWebDeployPackageLog)
	if (($Build -eq $null) -or ($Build.ExitCode.Equals(1))){
		Write-Host "unable to build web deploy package"
		exit -1
	}

	$zipFile = Get-Item $webdeployPackageFile
	$cmdFile = Get-Item $webdeployPackagePath"Pipe.Web.deploy.cmd"
	if($zipFile -ne $null -and  $cmdFile -ne $null){
		Write-Host "successfully created web deploy package"
	}
	else{
		exit -1
	}
}

function AddItemsForNuGetPackagingToPackage(){
	Copy-Item -Path "..\NuGet" -Destination $deployPackagePath -Recurse
	Copy-Item -Path "CreateAndPushNuGetPackage.ps1" -Destination $deployPackagePath"/Nuget"	
}

function AddInstallScriptsToPackage(){
	Copy-Item -Path ".\Tools" -Destination $deployPackagePath -Recurse
	Copy-Item -Path "DeploySite.ps1" -Destination $deployPackagePath"Tools"
}

function AddWebTestItemsToPackage(){
	Copy-Item -Path ".\TestRunner" -Destination $webtestDeployPackagePath"TestRunner" -Recurse
	Copy-Item -Path ("..\WebTest\bin\" + $Configuration) -Destination $webtestDeployPackagePath"bin" -Recurse
	Copy-Item -Path "installAndRunWebTests.ps1" -Destination $webtestDeployPackagePath
	Copy-Item -Path "RunWebTests.ps1" -Destination $webtestDeployPackagePath
}

function CreateDeployPackage(){
	CleanDirectory
	CreateWebDeployPackage
	AddItemsForNuGetPackagingToPackage
	AddInstallScriptsToPackage
	AddWebTestItemsToPackage
}