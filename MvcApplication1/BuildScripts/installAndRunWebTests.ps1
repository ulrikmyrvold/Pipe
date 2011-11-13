
. ..\Tools\DeploySite.ps1
. .\RunWebTests.ps1

Function CheckForErrors() {
  if (!$?) {
	Write-Host "FAILED! STOPPING SCRIPT EXECUTION" -foregroundcolor red
    exit -1
  }
}

Function DoesNotExistSite($siteName){
	$webSite = Get-Item "IIS:\sites\$siteName" -ErrorAction SilentlyContinue
	return ($webSite -eq $null)
}

Function ExistsSite($siteName){
	return !(DoesNotExistSite $siteName)
}

$webAdminSnapin = Get-PSSnapin | where {$_.Name -eq 'WebAdministration'}
if($webAdminSnapin -eq $null){
  import-module WebAdministration
}

Write-Host "Deploying web application to test system"
$deployPackagePath = Get-Item -Path '../Content/Pipe.Web.zip'
DeployWebApplicationSite 'PipeWebTest' 'd:\Temp\PipeWebTest' '*' '80' 'pipeWebTest' 'pipeWebTest' $null $deployPackagePath "$env:ProgramFiles\IIS\Microsoft Web Deploy V2\msdeploy.exe"

RunWebtTests