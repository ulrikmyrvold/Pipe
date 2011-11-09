. .\RunUnitTests.ps1
#. .\RunJSTests.ps1
#. .\CreatePackage.ps1

$MsBuild = $env:systemroot + "\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe";
$SlnFilePath = "..\Pipe.sln"
$Configuration = "Debug"
$BuildLog ="..\build.log"


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
	exit -1
}


# Start the build
cls
Write-Host "starting build"


$Build = Start-Process @BuildArgs
if($Build.ExitCode.Equals(1)){
	Error "Build failed" $BuildLog
}

RunUnitTests
.\CreateWebDeployPackage

#Write-Host "running JS tests"
#RunJStests
#Write-Host "creating NuGetPackage"
#createPackage
#Write-Host "pushing package"
#pushPackage