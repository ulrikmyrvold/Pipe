. .\ReadConfiguration.ps1

if($args.Count -ne 1){
	throw "The following parameter is required: (1) Environmet name"
}
$environment = $args[0]

$DotNetVersionNumber = ReadValueFromConfig 'DotNetVersionNumber'
$Configuration = ReadValueFromConfig 'BuildConfiguration' 
$BinDirectory = ReadValueFromConfig 'UnittestBinDirectory'
$TestrunOutput = ReadValueFromConfig 'UnittestOutputFile'
$TestrunLog = ReadValueFromConfig 'UnittestLogFile'
$Testrunner = ReadValueFromConfig 'NunitTestRunnerFile' 
$TestrunnerConfig = ReadValueFromConfig 'NunitTestRunnerConfigFile' 
$UnitTestDll = ReadValueFromConfig 'UnittestDll' 

function RunTests()
{
	$TestRunArgs = @{
		FilePath = $Testrunner
		WorkingDirectory = $BinDirectory + $Configuration
	 	ArgumentList = $UnitTestDll, "/xml " + $TestrunOutput
		RedirectStandardOutput = $TestrunLog 
		NoNewWindow = $true
		PassThru = $true
		Wait = $true
	}	
	$testrun = Start-Process @TestRunArgs
	Write-Host (Get-Content -Path $TestrunLog)
	if (($testrun -eq $null) -or ($testrun.ExitCode -ne 0)){
		throw "Tests failed"
	}
}


function AppendStartupElement($xmlDoc){
	Write-Host "adding startup element to configuration file"
	
	$startup = $xmlDoc.CreateElement("startup")
	$requiredRuntime = $xmlDoc.CreateElement("requiredRuntime")
	$requiredRuntimeAttr = $xmlDoc.CreateAttribute("version")
	$requiredRuntimeAttr.Value = $DotNetVersionNumber
	$requiredRuntime.Attributes.Append($requiredRuntimeAttr)
	$startup.AppendChild($requiredRuntime)
	
	$xmlnode = $xmlDoc.get_DocumentElement()
	$xmlnode.AppendChild($startup)
	
}

function TweakNunitConfig(){
	#make sure required runtime is set, otherwise nunit-agent.exe will not terminate properly
	$configfile = Get-Item -Path $TestrunnerConfig

	[xml]$xml = Get-Content $configfile.FullName
	$startup = $xml.get_DocumentElement().startup
	if($startup -eq $null){
		AppendStartupElement $xml
		$xml.Save($configfile.FullName)	
		$startup = $xml.get_DocumentElement().startup
	}
	
	$value = $startup.requiredRuntime.GetAttribute("version")
	if(!($value -eq $DotNetVersionNumber))
	{
		Write-Host "updating runtime version in configuraiton file"
		$value = $DotNetVersionNumber
		$xml.configuration.startup.requiredRuntime.version = $value		
		$xml.Save($configfile)	
	}
}

Write-Host
Write-Host "Running unit tests"
TweakNunitConfig
RunTests
