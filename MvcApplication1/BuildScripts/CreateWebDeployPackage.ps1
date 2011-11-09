﻿$MsBuild = $env:systemroot + "\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe";
$ProjectFilePath = "..\Pipe.Web\Pipe.Web.csproj"
$Configuration = "Debug"
$BuildLog ="..\build_webDeployPackage.log"
$webdeployPackageFile = "..\WebDeployPackages\Pipe.Web.zip"


$BuildArgs = @{
 FilePath = $MsBuild
 ArgumentList = $ProjectFilePath, "/t:package", ("/p:Configuration=" + $Configuration+ ";PackageLocation=" + $webdeployPackageFile), "/v:minimal"
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

$zipFile = Get-Item "..\WebDeployPackages\Pipe.Web.zip"
$cmdFile = Get-Item "..\WebDeployPackages\Pipe.Web.deploy.cmd"
if($zipFile -ne $null -and  $cmdFile -ne $null){
	write "successfully created web deploy package"
}
else{
	exit -1
}