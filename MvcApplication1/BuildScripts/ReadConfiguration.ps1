$configfile = ".\configuration.xml"

function ReadValueFromConfig($configKey){
	$xml = [xml](Get-Content $configfile)
	if($xml.SelectSingleNode("Root/Configuration[@environment='" + $environment + "']") -eq $null ){
		throw 'No configuration for environment ' + $environment + ' found.'
	}
	$configValue = $xml.SelectSingleNode("Root/Configuration[@environment='" + $environment + "']/" + $configKey).InnerText
	return $configValue
}