#Author: ulrik myrvold
#Date: 10/7/2011 11:13:10 AM
#Script: CreatePackage

#nuget pack MvcApplication1.csproj

$workingDirectory = "..\Nuget"
$NugetPushUrl = "http://localhost:105/"
$NugetApiKey = "d9ba4dfa-1b29-4509-9c6c-4d78af403e53"

$NugetArgs = @{
	FilePath = "NuGet.exe"
	WorkingDirectory = $workingDirectory
	Wait = $true
	PassThru = $true
}


function CleanDirectory(){
	$nupkgfiles = $workingDirectory + "\*.nupkg"
	Remove-Item $nupkgfiles
}

function CopyPowerShellScripts{
	if(Test-Path $workingDirectory"/Tools"){
		Remove-Item -Path $workingDirectory"/Tools" -Recurse
	}
	Copy-Item -Path ".\Tools" -Destination $workingDirectory -Recurse
}

function createPackage(){
	CleanDirectory
	CopyPowerShellScripts
	$NugetArgs.ArgumentList = "pack"
	$nuget = Start-Process @NugetArgs
	Write-Host $nuget.ExitCode
 }
 
function pushPackage(){
	$filename = Get-Item $workingDirectory"\*.nupkg"
	$NugetArgs.ArgumentList = "push", $filename.Name, "-s " + $NugetPushUrl + $NugetApiKey
	$nuget = Start-Process @NugetArgs
	Write-Host $nuget.ExitCode 
} 
 