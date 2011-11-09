
. .\DeploySite.ps1

Function CheckForErrors() {
  if (!$?) {
	Write-Host "FAILED! STOPPING SCRIPT EXECUTION" -foregroundcolor red
    exit
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

Push-Location

Set-Location "..\Content"
DeployWebApplicationSite 'PipeDeploy' 'd:\Temp\PipeDeploy' '*' '80' 'pipeDeploy' 'Pipe' $null 'Pipe.Web.zip' "$env:ProgramFiles\IIS\Microsoft Web Deploy V2\msdeploy.exe"

Pop-Location