#Author: ulrik myrvold
#Date: 10/7/2011 10:48:25 AM
#Script: DeploySite
$tmpDir = $args[0]
$tmpDir1 = $tmpDir.ToString() + "\content"
$installDir = $args[1]
$binDir = $installDir.ToString() + "\bin"

#copy bin content
$tmpBinFiles = $tmpDir.ToString() + "\lib\net40\*.dll" 
$binDestination = $tmpDir1.ToString() + "\bin"
mkdir $binDestination
Copy-Item $tmpBinFiles -Destination $binDestination

#copy content to installdir
Copy-Item $tmpDir1 -Destination $installDir -Force -Recurse
