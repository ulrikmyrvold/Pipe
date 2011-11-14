$MsBuild = $env:systemroot + "\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe";
$SlnFilePath = "..\Pipe.sln"
$Configuration = "Release"
$BuildLog ="..\build.log"

$BuildArgs = @{
 FilePath = $MsBuild
 ArgumentList = $SlnFilePath, "/t:rebuild", ("/p:Configuration=" + $Configuration), "/v:minimal"
 RedirectStandardOutput = $BuildLog
 NoNewWindow = $true 
 Wait = $true
 PassThru = $true
 }

Write-Host
Write-Host "Starting build"
$Build = Start-Process @BuildArgs
Write-Host (Get-Content -Path $BuildLog)

if (($Build -eq $null) -or ($Build.ExitCode.Equals(1))){
	Write-Host "Build failed" 
	Write-Host $BuildLog
	
	exit -1
}