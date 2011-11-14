Function CheckForErrors() {
  if (!$?) {
	Write-Host "FAILED! STOPPING SCRIPT EXECUTION" -foregroundcolor red
    exit -1
  }
}

cls
.\BuildApplication.ps1
CheckForErrors
.\RunUnitTests.ps1
CheckForErrors
.\CreateDeployPackage.ps1
CheckForErrors