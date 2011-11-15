. .\Tools\ReadConfiguration.ps1

if($args.Count -ne 1){
	throw "The following parameter is required: (1) Environmet name"
}
$environment = $args[0]

$DotNetVersionNumber = ReadValueFromConfig 'DotNetVersionNumber'
$WorkingDirectory = ReadValueFromConfig 'WebTestBinDirectoryForTestRun'
$TestrunOutput = ReadValueFromConfig 'WebTestOutputFile'
$TestrunLog = ReadValueFromConfig 'WebTestLogFile'
$Testrunner = ReadValueFromConfig 'WebTestRunnerFile' 
$TestrunnerConfig = ReadValueFromConfig 'WebTestRunnerConfigFile' 
$WebTestDll = ReadValueFromConfig 'WebTestDll' 

function RunTests()
{
	$TestRunArgs = @{
		FilePath = $Testrunner
		WorkingDirectory = $WorkingDirectory
	 	ArgumentList = $WebTestDll, "/xml " + $TestrunOutput
		NoNewWindow = $true 
		RedirectStandardOutput = $TestrunLog 
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
Write-Host "Running web tests"
TweakNunitConfig
RunTests
