. .\Tools\DeploySite.ps1
. .\Tools\ReadConfiguration.ps1

Function CheckForErrors() {
  if (!$?) {
	Write-Error "FAILED! STOPPING SCRIPT EXECUTION"
    exit 1
  }
}

if($args.Count -ne 2){
	Write-Error "Running the deploy requires the following parameters: (1) Environmet name, (2) Version number for the NuGet package"
	exit 1
}
$environment = $args[0]
$versionNumber = $args[1]

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

Write-Host
Write-Host "Deploying web application to test system"
$deployPackagePath = Get-Item -Path '.\Content\Pipe.Web.zip'
DeployWebApplicationSite $webApplicationSiteName $physicalSitePath $ipAddress $port $hostName $appPoolName $null $deployPackagePath "$env:ProgramFiles\IIS\Microsoft Web Deploy V2\msdeploy.exe"

.\Webtest\RunWebTests.ps1 $environment
.\Nuget\CreateAndPushNuGetPackage.ps1 $environment $versionNumber
CheckForErrors