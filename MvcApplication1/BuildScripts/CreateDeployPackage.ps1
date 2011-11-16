. .\ReadConfiguration.ps1

if($args.Count -ne 1){
	throw "The following parameter is required: (1) Environmet name"
}
$environment = $args[0]

$MsBuild = $env:systemroot + "\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe";
$deployPackagePath = ReadValueFromConfig 'DeployPackagePath'
$ProjectFilePath = ReadValueFromConfig 'WebProjectFile'
$Configuration = ReadValueFromConfig 'BuildConfiguration'
$BuildWebDeployPackageLog = ReadValueFromConfig 'BuildWebDeployPackageLogFile'
$webdeployPackagePath = ReadValueFromConfig 'WebDeployPackagePath'
$webdeployPackageFile = $webdeployPackagePath + (ReadValueFromConfig 'BuildWebDeployPackageFile')
$webtestDeployPackagePath = ReadValueFromConfig 'WebtestDeployPackagePath'
$NugetItemsDirectory = ReadValueFromConfig 'NugetItemsDirectory'
$NugetPowerShellSciptsDirectory = ReadValueFromConfig 'NugetPowerShellSciptsDirectory'
$NunitTestRunnerFile = ReadValueFromConfig 'NunitTestRunnerFile'
$NunitTestRunnerConfigFile = ReadValueFromConfig 'NunitTestRunnerConfigFile'
$NunitTestRunnerLibDirectory = ReadValueFromConfig 'NunitTestRunnerLibDirectory'
$WebTestBinDirectory = ReadValueFromConfig 'WebTestBinDirectoryForDeployPackage'


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
		throw "Unable to build web deploy package"
	}

	$zipFile = Get-Item $webdeployPackageFile
	if($zipFile -ne $null){
		Write-Host "Successfully created web deploy package"
	}
	else{
		throw "Web deploy package hasn't been created"
	}
}

function AddItemsForNuGetPackagingToPackage(){
	Copy-Item -Path $NugetItemsDirectory -Destination $deployPackagePath -Recurse
	Copy-Item -Path "CreateAndPushNuGetPackage.ps1" -Destination $deployPackagePath"/Nuget"	
}

function AddInstallScriptsToPackage(){
	Copy-Item -Path $NugetPowerShellSciptsDirectory -Destination $deployPackagePath -Recurse
	Copy-Item -Path "DeploySite.ps1" -Destination $deployPackagePath"Tools"
	Copy-Item -Path "ReadConfiguration.ps1" -Destination $deployPackagePath"Tools"
}

function AddWebTestItemsToPackage(){
	New-Item -Name $webtestDeployPackagePath"TestRunner"  -ItemType directory | Out-Null
	Copy-Item -Path $NunitTestRunnerFile -Destination $webtestDeployPackagePath"TestRunner" 
	Copy-Item -Path $NunitTestRunnerConfigFile -Destination $webtestDeployPackagePath"TestRunner"
	Copy-Item -Path $NunitTestRunnerLibDirectory -Destination $webtestDeployPackagePath"TestRunner" -Recurse
	Copy-Item -Path ($WebTestBinDirectory + $Configuration) -Destination $webtestDeployPackagePath"bin" -Recurse
	
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
Copy-Item -Path "configuration.xml" -Destination $deployPackagePath