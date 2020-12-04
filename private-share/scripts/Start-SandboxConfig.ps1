[CmdletBinding()]
param()

Write-Warning "Starting to configure Windows Sandbox VM"

Set-ExecutionPolicy -ExecutionPolicy "Bypass" -Scope "CurrentUser" -Force

$scriptPath = $PSScriptRoot

$scriptsToRun = @(
    [System.IO.Path]::Combine($scriptPath, "Install-EdgeEnterprise.ps1"),
    [System.IO.Path]::Combine($scriptPath, "Configure-EdgeSettings.ps1"),
    [System.IO.Path]::Combine($scriptPath, "Install-Sysmon.ps1")
)

foreach ($scriptFile in $scriptsToRun) {
    . "$($scriptFile)" -Verbose
}