$MsBuild = $env:systemroot + "\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe";
$ProjectFilePath = "..\Pipe.Web\Pipe.Web.csproj"
$Configuration = "Debug"
$BuildLog ="..\build.log"


$BuildArgs = @{
 FilePath = $MsBuild
 ArgumentList = $ProjectFilePath, "/t:package", ("/p:Configuration=" + $Configuration), "/v:minimal"
 RedirectStandardOutput = $BuildLog
 Wait = $true
 PassThru = $true
 }
 
 write "building web deploy package"
$Build = Start-Process @BuildArgs
if($Build.ExitCode.Equals(1)){
	write "unable to build web deploy package"
	exit -1
}

$zipFile = Get-Item "..\Pipe.Web\obj\debug\package\Pipe.Web.zip"
$cmdFile = Get-Item "..\Pipe.Web\obj\debug\package\Pipe.Web.deploy.cmd"
if($zipFile -ne $null -and  $cmdFile -ne $null){
	write "successfully created web deploy package"
}
else{
	exit -1
}