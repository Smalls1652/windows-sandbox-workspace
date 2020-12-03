[CmdletBinding()]
param(

)

$installDir = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop\shared\files\browsers\")

Write-Verbose "Installing Microsoft Edge"
Start-Process -FilePath "msiexec" -ArgumentList @("/i", "MsEdgeEnterpriseInstall.msi", "/qn") -WorkingDirectory $installDir -Wait