function Get-SandboxModuleConfig {
    [CmdletBinding()]
    param(

    )

    $moduleConfig = Get-Content -Path $Script:moduleConfigFilePath -Raw -ErrorAction "Stop" | ConvertFrom-Json

    return $moduleConfig
}