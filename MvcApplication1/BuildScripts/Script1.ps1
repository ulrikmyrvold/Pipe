#Author: ulrik myrvold
#Date: 10/4/2011 10:53:03 AM
#Script: Script1

. .\RunUnitTests.ps1
. .\RunJSTests.ps1
. .\CreatePackage.ps1

$MsBuild = $env:systemroot + "\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe";
$SlnFilePath = "E:\PoC\JSTestDriver\VS\MvcApplication1\MvcApplication1.sln"
$Configuration = "Debug"
$BuildLog ="E:\PoC\JSTestDriver\VS\MvcApplication1\build.log"


$BuildArgs = @{
 FilePath = $MsBuild
 ArgumentList = $SlnFilePath, "/t:rebuild", ("/p:Configuration=" + $Configuration), "/v:minimal"
 RedirectStandardOutput = $BuildLog
 Wait = $true
 PassThru = $true
 }

function Error($message, $value){
	
	Write-Host $message 
	
	Get-Content $value | ForEach-Object {
		if($_ -match "error"){
			Write-Host $_ -foregroundcolor red
		}
		else{
	 		Write-Host $_ -foregroundcolor black
		}
	}
	exit
}


# Start the build
cls
Write-Host "starting build"

$Build = Start-Process @BuildArgs
if($Build.ExitCode.Equals(1)){
	Error "Build failed" $BuildLog
}

Write-Host "running unit tests"
RunUnitTests
Write-Host "running JS tests"
RunJStests
Write-Host "creating NuGetPackage"
createPackage
Write-Host "pushing package"
pushPackage
