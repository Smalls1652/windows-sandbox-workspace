[CmdletBinding()]
param(

)

$scriptPath = $PSScriptRoot

$outPath = [System.IO.Path]::Combine($scriptPath, "private-share\files\browsers\")

$edgeDownloadUri = "http://go.microsoft.com/fwlink/?LinkID=2093437"

$tempGuid = New-Guid
$tempPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "$($tempGuid.Guid.ToString())\")

$tempDir = New-Item -Path $tempPath -ItemType "Directory" -Force
$tempInstallFilePath = [System.IO.Path]::Combine($tempDir.FullName, "MsEdgeEnterpriseInstall.msi")

Invoke-WebRequest -Uri $edgeDownloadUri -OutFile $tempInstallFilePath

switch (Test-Path -Path $outPath) {
    $false {
        $null = New-Item -Path $outPath -ItemType "Directory" -Force
        break
    }
}
Copy-Item -Path $tempInstallFilePath -Destination $outPath

Remove-Item -Path $tempDir.FullName -Force -Recurse