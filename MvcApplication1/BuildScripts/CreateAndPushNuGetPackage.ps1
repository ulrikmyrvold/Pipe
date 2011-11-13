$WorkingDirectory = "..\NuGet\"
$ToolsDirectory = $workingDirectory + "\Tools"
$ContentDirectory = $workingDirectory + "\Content"
$NugetPushUrl = "http://localhost:105/"
$NugetApiKey = "d9ba4dfa-1b29-4509-9c6c-4d78af403e53"

$NugetArgs = @{
	FilePath = "NuGet.exe"
	WorkingDirectory = $WorkingDirectory
	Wait = $true
	PassThru = $true
}


function CleanDirectory(){
	Remove-Item ($WorkingDirectory + "*.nupkg")
}

function CopyPowerShellScripts{
	if(Test-Path $ToolsDirectory){
		Remove-Item -Path $ToolsDirectory -Recurse
	}
	Copy-Item -Path "..\Tools" -Destination $ToolsDirectory -Recurse
}

function CopyContentItems{
	if(Test-Path $ContentDirectory){
		Remove-Item -Path $ContentDirectory -Recurse
	}
	Copy-Item -Path "..\Content" -Destination $ContentDirectory -Recurse
}

function createPackage($versionNumber){
	Write-Host "Creating NuGet-package"
	CleanDirectory
	CopyPowerShellScripts
	CopyContentItems
	$NugetArgs.ArgumentList = "pack", "-Exclude " + "CreateAndPushNuGetPackage.ps1", "-Version " + $versionNumber
	$nuget = Start-Process @NugetArgs
	if (($nuget -eq $null) -or ($nuget.ExitCode.Equals(1))){
		exit -1
	}
 }
 
function pushPackage(){
	Write-Host "Pushing NuGet-package to gallery"
	$filename = Get-Item ($WorkingDirectory + "*.nupkg")
	$NugetArgs.ArgumentList = "push", $filename.Name, "-s " + $NugetPushUrl + $NugetApiKey
	$nuget = Start-Process @NugetArgs
	if (($nuget -eq $null) -or ($nuget.ExitCode.Equals(1))){
		exit -1
	} 
} 
 
function CreatePushNuGetPackageAnPushToGallery($versionNumber) {
	createPackage $versionNumber
	pushPackage 
}