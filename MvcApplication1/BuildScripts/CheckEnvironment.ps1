#Author: ulrik myrvold
#Date: 10/11/2011 10:15:53 AM
#Script: CheckEnvironment
$path = $Env:Path.ToString()

$MsBuildpath = $env:systemroot + "\Microsoft.NET\Framework\v4.0.30319\Not\MSBuild.exe";

if(Test-Path $MsBuildpath){
	
}