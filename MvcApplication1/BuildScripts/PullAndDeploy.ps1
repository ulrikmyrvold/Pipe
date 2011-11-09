#Author: ulrik myrvold
#Date: 10/7/2011 1:05:04 PM
#Script: PullAndDeploy

#Pulls package from NuGet server and runs contained deploymentscript

$applicationName = "Pipe.Web"
$workingDirectory = "D:\Temp\PipeDeploy"
$NugetPullUrl = "http://localhost:105/nuget"

$NugetArgs = @{
	FilePath = "NuGet.exe"
	ArgumentList = "install", $applicationName, "-s "+$NugetPullUrl 
	Wait = $true
	PassThru = $true
}

function PullPackage(){
	$nuget = Start-Process @NugetArgs
	Write-Host $nuget.ExitCode
 }
 
 Push-Location $workingDirectory
 Mkdir "tmp"
 Push-Location ".\tmp"
 PullPackage
 $directory = Get-Item ".\*"
 Push-Location $directory
 $deployfile = Get-Item ".\source\DeploySite.ps1"
 Pop-Location
 Pop-Location
 Write-Host "running " + $deployfile
 if((Get-Item "web") -eq $null){
 	mkdir "web"
 }
 
 $installTo = $workingDirectory + "\web"
 . $deployfile $directory $installTo
 
 
 Remove-Item "tmp" -Recurse
 Pop-Location

