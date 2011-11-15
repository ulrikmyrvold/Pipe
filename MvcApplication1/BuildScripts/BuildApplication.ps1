. .\ReadConfiguration.ps1

if($args.Count -ne 1){
	throw "The following parameter is required: (1) Environmet name"
}
$environment = $args[0]

$MsBuild = $env:systemroot + "\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe";
$SlnFilePath = ReadValueFromConfig 'SolutionFile' 
$Configuration = ReadValueFromConfig 'BuildConfiguration' 
$BuildLog = ReadValueFromConfig 'BuildLogFile'

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
	Write-Host $BuildLog
	throw "Build failed"
}