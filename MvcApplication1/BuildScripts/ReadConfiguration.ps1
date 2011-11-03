#Author: ulrik myrvold
#Date: 10/7/2011 9:25:38 AM
#Script: ReadConfiguration

$configuration = $args[0]

if(!($configuration.split(".")[-1] -eq "input")){
	$configuration = $configuration  + ".input"
	}
	
$input = Get-Content $configuration
$values = @{}
$input | foreach{	
	$tuple = $_.split("=")
	$key = $tuple[0].trim()
	$value = $tuple[1].trim()
	$values.Add($key,$value)
}

# $values contain parameters from build configuration file