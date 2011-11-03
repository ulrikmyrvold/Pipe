#Author: ulrik myrvold
#Date: 10/4/2011 11:17:06 AM
#Script: RunJSTests

function SetupJsTestDriver(){
		Write-Host "starting JsTestDriver Server on port 9876";
		
		$Errorlog = "E:\PoC\JSTestDriver\error.log"
		$FirefoxPath = "{}"
		
		$Arguments = @()
		$Arguments += "-jar"
 		$Arguments += "E:\PoC\JSTestDriver\JsTestDriver-1.3.3b.jar"
 		$Arguments += "--port 9876"
 		$Arguments += "--browser `"C:\Program Files (x86)\Mozilla Firefox\firefox.exe`""
				
		$proc = Start-Process -FilePath "Java.exe" -ArgumentList $Arguments -RedirectStandardOutput $Errorlog
		
		Write-Host "JsTestDriver server started"
}

function CheckJsTestDriver(){
	trap [Exception]{
		SetupJsTestDriver
		Start-Sleep 5
		continue;
	}
	
	$r = [System.Net.WebRequest]::Create("http://localhost:9876/")
	$resp = $r.GetResponse()	
}


function RunJStests()
{
	CheckJsTestDriver
	$WorkingDirectory = "E:\PoC\JSTestDriver\VS\MvcApplication1\Tests"
	$TestrunLog = "E:\PoC\JSTestDriver\TestRun.log"
	
	$TestRunArgs = @{
		FilePath = "Java.exe"
		WorkingDirectory = $WorkingDirectory
	 	ArgumentList = "-jar", "E:\PoC\JSTestDriver\JsTestDriver-1.3.3b.jar", "--tests all"
		RedirectStandardOutput = $TestrunLog 
		PassThru = $true
		Wait = $true
	}	
	$proc = Start-Process @TestRunArgs
	Get-Content $TestrunLog
}