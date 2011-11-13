function RunTests()
{
	$WorkingDirectory = "..\WebTest\bin\Release"
	$TestrunOutput = "..\WebTestRun.xml"
	$TestrunLog = "..\WebTestRun.log"
	
	$TestRunArgs = @{
		FilePath = ".\TestRunner\nunit-console.exe"
		WorkingDirectory = $WorkingDirectory
	 	ArgumentList = "WebTest.dll", "/xml " + $TestrunOutput
		NoNewWindow = $true 
		RedirectStandardOutput = $TestrunLog 
		PassThru = $true
		Wait = $true
	}	
	$testrun = Start-Process @TestRunArgs
	Write-Host (Get-Content -Path $TestrunLog)
	
	if ($testrun.ExitCode.Equals(1)){
		exit -1
	}
		
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

	$configfile = Get-Item -Path ".\TestRunner\nunit-console.exe.config"

	[xml]$xml = Get-Content $configfile.FullName
	$startup = $xml.get_DocumentElement().startup
	if($startup -eq $null){
		AppendStartupElement $xml
		$xml.Save($configfile.FullName)	
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

function RunWebtTests(){
	TweakNunitConfig
	Write-Host "running web tests"
	RunTests
}