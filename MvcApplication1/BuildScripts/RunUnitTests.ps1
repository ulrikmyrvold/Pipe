#Author: ulrik myrvold
#Date: 10/5/2011 8:35:04 AM
#Script: RunUnitTests

function RunTests()
{
	$WorkingDirectory = "E:\PoC\JSTestDriver\VS\MvcApplication1\Tests\bin\Debug"
	$TestrunOutput = "E:\PoC\JSTestDriver\VS\UnitTestRun.xml"
	$TestrunLog = "E:\PoC\JSTestDriver\UnitTestRun.log"
	
	$TestRunArgs = @{
		FilePath = "C:\Program Files (x86)\NUnit 2.5.8\bin\net-2.0\nunit-console.exe"
		WorkingDirectory = $WorkingDirectory
	 	ArgumentList = "Tests.dll", "/xml " + $TestrunOutput
		RedirectStandardOutput = $TestrunLog 
		#PassThru = $true
		Wait = $true
	}	
	Start-Process @TestRunArgs
	Get-Content $TestrunLog
}


function AppendStartupElement($xmlDoc){
	Write-Host "adding startup element to configuration file"
	
	$startup = $xmlDoc.CreateElement("startup")
	$requiredRuntime = $xmlDoc.CreateElement("requiredRuntime")
	$requiredRuntimeAttr = $xmlDoc.CreateAttribute("version")
	$requiredRuntimeAttr.Value = "4.0.30318"
	$requiredRuntime.Attributes.Append($requiredRuntimeAttr)
	$startup.AppendChild($requiredRuntime)
	
	$xmlnode = $xmlDoc.get_DocumentElement()
	$xmlnode.AppendChild($startup)
	
}

function TweakNunitConfig(){
	#make sure required runtime is set, otherwise nunit-agent.exe will not terminate properly
	
	#$configfile = "E:\PoC\JSTestDriver\VS\nunit-console.exe.copy.config"

	$configfile = "C:\Program Files (x86)\NUnit 2.5.8\bin\net-2.0\nunit-console.exe.config"

	[xml]$xml = Get-Content $configfile
	$startup = $xml.get_DocumentElement().startup
	if($startup -eq $null){
		AppendStartupElement $xml
		$xml.Save($configfile)	
		$startup = $xml.get_DocumentElement().startup
	}
	
	$value = $startup.requiredRuntime.GetAttribute("version")
	if(!($value -eq "4.0.30319"))
	{
		Write-Host "updating runtime version in configuraiton file"
		$value = "4.0.30319"
		$xml.configuration.startup.requiredRuntime.version = $value		
		$xml.Save($configfile)	
	}
}

function RunUnitTests(){
	TweakNunitConfig
	Write-Host "running unit tests"
	RunTests
}
