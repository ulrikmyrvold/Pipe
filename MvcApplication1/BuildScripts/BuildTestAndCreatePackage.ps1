if($args.Count -ne 1){
	Write-Error "The following parameter is required: (1) Environmet name"
	exit 1
}
$environment = $args[0]

cls
.\BuildApplication.ps1 $environment
.\RunUnitTests.ps1 $environment
.\CreateDeployPackage.ps1 $environment
