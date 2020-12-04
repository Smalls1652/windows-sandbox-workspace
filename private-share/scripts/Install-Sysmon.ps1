[CmdletBinding()]
param(

)

$installDir = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop\private\files\tools\Sysmon_2020-11-25\")
$installFile = [System.IO.Path]::Combine($installDir, "Sysmon64.exe")
$configFile = [System.IO.Path]::Combine($installDir, "sysmonconfig-export.xml")

Write-Verbose "Installing Sysmon"
Start-Process -FilePath $installFile -ArgumentList @("-i", "$($configFile)", "-accepteula") -WorkingDirectory $installDir -Wait -NoNewWindow