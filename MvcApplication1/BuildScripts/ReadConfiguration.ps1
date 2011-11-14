$configfile = ".\configuration.xml"

function ReadValueFromConfig($configKey){
	$xml = [xml](Get-Content $configfile)
	$configValue = $xml.SelectSingleNode("Root/Configuration/" + $configKey).InnerText
	return $configValue
}
