. .\RunUnitTests.ps1
. .\CreateDeployPackage

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
	exit -1
}

cls
Write-Host "starting build"


$Build = Start-Process @BuildArgs
Write-Host (Get-Content -Path $BuildLog)

if (($Build -eq $null) -or ($Build.ExitCode.Equals(1))){
	Error "Build failed" $BuildLog
}

RunUnitTests
CreateDeployPackage
