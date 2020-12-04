[CmdletBinding()]
param(

)

$ScriptLocation = $PSScriptRoot

$csProjectDir = [System.IO.Path]::Combine($ScriptLocation, "src\LibWindowsSandbox\")
$csProjectPublishDir = [System.IO.Path]::Combine($csProjectDir, "bin\Debug\net5.0\publish\")

$moduleProjectDir = [System.IO.Path]::Combine($ScriptLocation, "src\WindowsSandboxConfig\")

$buildDir = [System.IO.Path]::Combine($ScriptLocation, "build-out\")
$buildModuleDir = [System.IO.Path]::Combine($buildDir, "WindowsSandboxConfig\")

$filesToCopy = @(
            ([System.IO.Path]::Combine($csProjectPublishDir, "LibWindowsSandbox.dll"))
)

switch (Test-Path -Path $buildDir) {
    $false {
        $null = New-Item -Type "Directory" -Path $buildDir
        break
    }
}

switch (Test-Path -Path $buildModuleDir) {
    $true {
        Remove-Item -Path $buildModuleDir -Recurse -Force
        break
    }
}

Copy-Item -Path $moduleProjectDir -Destination $buildDir -Recurse


foreach ($item in $filesToCopy) {
    Copy-Item -Path $item -Destination $buildModuleDir
}