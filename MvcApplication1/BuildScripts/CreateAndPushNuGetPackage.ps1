. .\Tools\ReadConfiguration.ps1

if($args.Count -ne 2){
	throw "The following parameters are required: (1) Environmet name, (2) Version number for the NuGet package"
}
$environment = $args[0]
$versionNumber = $args[1]

$WorkingDirectory = ReadValueFromConfig 'NugetDirectoryInDeployPackage'
$ToolsDirectory = $workingDirectory + "\Tools"
$ContentDirectory = $workingDirectory + "\Content"
$NugetPushUrl = ReadValueFromConfig 'NugetPushUrl'
$NugetApiKey = ReadValueFromConfig 'NugetApiKey'

$NugetArgs = @{
	FilePath = $WorkingDirectory + ".\bin\NuGet.exe"
	WorkingDirectory = $WorkingDirectory
	Wait = $true
	PassThru = $true
	NoNewWindow = $true
}

function CleanDirectory(){
	Remove-Item ($WorkingDirectory + "*.nupkg")
}

function CopyPowerShellScripts{
	if(Test-Path $ToolsDirectory){
		Remove-Item -Path $ToolsDirectory -Recurse
	}
	Copy-Item -Path ".\Tools" -Destination $ToolsDirectory -Recurse
}

function CopyContentItems{
	if(Test-Path $ContentDirectory){
		Remove-Item -Path $ContentDirectory -Recurse
	}
	Copy-Item -Path ".\Content" -Destination $ContentDirectory -Recurse
}

function createPackage($versionNumber){
	Write-Host
	Write-Host "Creating NuGet-package"
	CleanDirectory
	CopyPowerShellScripts
	CopyContentItems
	$NugetArgs.ArgumentList = "pack", "-Exclude " + "CreateAndPushNuGetPackage.ps1", "-Exclude " + "bin\Nuget.exe","-Version " + $versionNumber
	$nuget = Start-Process @NugetArgs
	if (($nuget -eq $null) -or ($nuget.ExitCode.Equals(1))){
		throw "NuGet-package has't been created" 
	}
 }
 
function pushPackage(){
	Write-Host
	Write-Host "Pushing NuGet-package to gallery"
	$filename = Get-Item ($WorkingDirectory + "*.nupkg")
	$NugetArgs.ArgumentList = "push", $filename.Name, "-s " + $NugetPushUrl + $NugetApiKey
	$nuget = Start-Process @NugetArgs
	if (($nuget -eq $null) -or ($nuget.ExitCode.Equals(1))){
		throw "NuGet-package has't been pushed to gallery" 
	} 
} 
 
createPackage $versionNumber
pushPackage 
