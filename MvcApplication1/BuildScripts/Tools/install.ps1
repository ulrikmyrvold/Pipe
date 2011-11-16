
. .\DeploySite.ps1
. .\ReadConfiguration.ps1

Function CheckForErrors() {
  if (!$?) {
	Write-Host "FAILED! STOPPING SCRIPT EXECUTION" -foregroundcolor red
    exit
  }
}

$environment = Read-Host "Type the environment's name where the package is installed."

$webApplicationSiteName = ReadValueFromConfig 'WebApplicationSiteName'
$physicalSitePath = ReadValueFromConfig 'PhysicalSitePath'
$ipAddress = ReadValueFromConfig 'IpAddress'
$port = ReadValueFromConfig 'Port'
$hostName = ReadValueFromConfig 'HostName'
$appPoolName = ReadValueFromConfig 'AppPoolName'

$webAdminSnapin = Get-PSSnapin | where {$_.Name -eq 'WebAdministration'}
if($webAdminSnapin -eq $null){
  import-module WebAdministration
}

$deployPackagePath = Get-Item -Path '..\Content\Pipe.Web.zip'
DeployWebApplicationSite $webApplicationSiteName $physicalSitePath $ipAddress $port $hostName $appPoolName $null $deployPackagePath "$env:ProgramFiles\IIS\Microsoft Web Deploy V2\msdeploy.exe"
