. .\ReadConfiguration.ps1

$MsBuild = $env:systemroot + "\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe";
$deployPackagePath = ReadValueFromConfig 'DeployPackagePath'

$ProjectFilePath = ReadValueFromConfig 'WebProjectFile'
$Configuration = ReadValueFromConfig 'BuildConfiguration'
$BuildWebDeployPackageLog = ReadValueFromConfig 'BuildWebDeployPackageLogFile'
$webdeployPackagePath = ReadValueFromConfig 'WebDeployPackagePath'
$webdeployPackageFile = $webdeployPackagePath + (ReadValueFromConfig 'BuildWebDeployPackageFile')
$webtestDeployPackagePath = ReadValueFromConfig 'WebtestDeployPackagePath'


$BuildWebDeployPackageArgs = @{
 FilePath = $MsBuild
 ArgumentList = $ProjectFilePath, "/t:package", ("/p:Configuration=" + $Configuration+ ";PackageLocation=" + $webdeployPackageFile), "/v:minimal"
 RedirectStandardOutput = $BuildWebDeployPackageLog
 NoNewWindow = $true
 Wait = $true
 PassThru = $true
 }
 
function CleanDirectory(){
	if(Test-Path $deployPackagePath){
		Remove-Item -Path $deployPackagePath"*" -Recurse -Force
	}
} 
 
function CreateWebDeployPackage(){
	$Build = Start-Process @BuildWebDeployPackageArgs
	Write-Host (Get-Content -Path $BuildWebDeployPackageLog)
	if (($Build -eq $null) -or ($Build.ExitCode.Equals(1))){
		Write-Host "unable to build web deploy package"
		exit -1
	}

	$zipFile = Get-Item $webdeployPackageFile
	if($zipFile -ne $null){
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
	
	Copy-Item -Path "RunWebTests.ps1" -Destination $webtestDeployPackagePath
}

Write-Host
Write-Host "Creating deploy package"
CleanDirectory
CreateWebDeployPackage
AddItemsForNuGetPackagingToPackage
AddInstallScriptsToPackage
AddWebTestItemsToPackage
Copy-Item -Path "installRunWebTestsCreateNuGetAndPushToGallery.ps1" -Destination $deployPackagePath
