#Author: ulrik myrvold
#Date: 10/7/2011 11:13:10 AM
#Script: CreatePackage

#nuget pack MvcApplication1.csproj

$workingDirectory = "..\MvcApplication1"
$NugetPushUrl = "http://localhost:105/"
$NugetApiKey = "SecretKey"

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

function createPackage(){
	CleanDirectory
	$NugetArgs.ArgumentList = "pack", "MvcApplication1.csproj"
	$nuget = Start-Process @NugetArgs
	Write-Host $nuget.ExitCode
 }
 
 function pushPackage(){
 	
	$filename = Get-Item "..\MvcApplication1\*.nupkg"
	$NugetArgs.ArgumentList = "push", $filename, "-s " + $NugetPushUrl + $NugetApiKey
	$nuget = Start-Process @NugetArgs
	Write-Host $nuget.ExitCode 
  } 
 
 createPackage
 #$filename = Get-Item "..\MvcApplication1\*.nupkg"
 #Write-Host $file
 pushPackage
 