
. .\Tools\DeploySite.ps1
. .\Webtest\RunWebTests.ps1
. .\Nuget\CreateAndPushNuGetPackage.ps1

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

if($args.Count -ne 1){
	Write-Host "Running the deploy requires the following parameters:" -foregroundcolor Red
	Write-Host "	(1) Version number for the NuGet package" -ForegroundColor Red
	exit -1
}
$versionNumber = $args[0]

Write-Host "Deploying web application to test system"
$deployPackagePath = Get-Item -Path '.\Content\Pipe.Web.zip'
DeployWebApplicationSite 'PipeWebTest' 'd:\Temp\PipeWebTest' '*' '80' 'pipeWebTest' 'pipeWebTest' $null $deployPackagePath "$env:ProgramFiles\IIS\Microsoft Web Deploy V2\msdeploy.exe"

RunWebtTests

CreatePushNuGetPackageAnPushToGallery $versionNumber