function Set-SandboxWorkspacePath {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Path = "$((Get-Location).Path)",
        [Parameter(Position = 1)]
        [switch]$SetAsDefault
    )

    $resolvedPath = Resolve-Path -Path $Path

    $oldWorkspacePath = $Script:workspacePath

    $Script:workspacePath = $resolvedPath.Path

    switch ($SetAsDefault) {
        $true {
            switch ((Test-Path -Path $Script:moduleConfigDirPath)) {
                $false {
                    $null = New-Item -Path $Script:moduleConfigDirPath -ItemType "Directory"
                    break
                }
            }

            $moduleConfig = [pscustomobject]@{
                "DefaultWorkspacePath" = $resolvedPath.Path
            }

            $moduleConfig | ConvertTo-Json -Depth 1 | Out-File -FilePath $Script:moduleConfigFilePath -Force
            break
        }
    }

    return [pscustomobject]@{
        "OldWorkspacePath" = $oldWorkspacePath;
        "NewWorkspacePath" = $Script:workspacePath
    }
}