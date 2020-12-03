[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$ConfigName = "Primary"
)

$scriptPath = $PSScriptRoot

$configsDirPath = [System.IO.Path]::Combine($scriptPath, ".configs\")
$sharedFolderPath = [System.IO.Path]::Combine($scriptPath, "shared\")
$dropboxFolderPath = [System.IO.Path]::Combine($scriptPath, "drop-box\")

$configFileOutPath = [System.IO.Path]::Combine($scriptPath, "$($ConfigName).wsb")

$variableRegex = [System.Text.RegularExpressions.Regex]::new("(?'variableObject'{{\s(?'variableName'.+?)\s}})")

$variableMappings = @(
    [pscustomobject]@{
        "VariableName" = "DefaultSharedFolder";
        "Content"      = ($sharedFolderPath.Substring(0, ($sharedFolderPath.Length - 1)));
    },
    [pscustomobject]@{
        "VariableName" = "DefaultDropBoxFolder";
        "Content"      = ($dropboxFolderPath.Substring(0, ($dropboxFolderPath.Length - 1)));
    },
    [pscustomobject]@{
        "VariableName" = "SandboxDesktop";
        "Content"      = "C:\Users\WDAGUtilityAccount\Desktop"
    },
    [pscustomobject]@{
        "VariableName" = "UserProfile";
        "Content"      = $env:USERPROFILE;
    }
)

$configFiles = Get-ChildItem -Path $configsDirPath

$chosenConfig = $configFiles | Where-Object { $PSItem.BaseName -eq $ConfigName }

switch ($null -eq $chosenConfig) {
    $true {
        $PSCmdlet.ThrowTerminatingError(
            [System.Management.Automation.ErrorRecord]::new(
                [System.Exception]::new("No config file was found with the name '$($ConfigName)'."),
                "ConfigFileNotFound",
                [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                $ConfigName
            )
        )
        break
    }
}

$configData = Get-Content -Path $chosenConfig.FullName -Raw | ConvertFrom-Json

$xmlObj = [System.Xml.XmlDocument]::new()

# Create top level 'Configuration' element
$configElement = $xmlObj.CreateElement("Configuration")

switch (($null -ne $configData.mappedFolders)) {
    $true {
        # Create 'MappedFolders' element
        $mappedFoldersElement = $xmlObj.CreateElement("MappedFolders")

        foreach ($folder in $configData.mappedFolders) {
            $hostFolderMatches = $variableRegex.Matches($folder.hostFolder)
            foreach ($foundVariable in $hostFolderMatches) {
                $replacementContent = ($variableMappings | Where-Object { $PSItem.VariableName -eq ($foundVariable.Groups['variableName'].Value) }).Content
                $folder.hostFolder = $folder.hostFolder -replace $foundVariable.Value, $replacementContent
            }

            $sandboxFolderMatches = $variableRegex.Matches($folder.sandboxFolder)
            foreach ($foundVariable in $sandboxFolderMatches) {
                $replacementContent = ($variableMappings | Where-Object { $PSItem.VariableName -eq ($foundVariable.Groups['variableName'].Value) }).Content
                $folder.sandboxFolder = $folder.sandboxFolder -replace $foundVariable.Value, $replacementContent
            }

            # Create 'MappedFolder' element
            $mappedFolderElement = $xmlObj.CreateElement("MappedFolder")

            # Create 'HostFolder' element
            $hostFolderAttr = $xmlObj.CreateElement("HostFolder")
            $hostFolderAttr.InnerText = $folder.hostFolder

            # Create 'SandboxFolder' element
            $sandboxFolderAttr = $xmlObj.CreateElement("SandboxFolder")
            $sandboxFolderAttr.InnerText = $folder.sandboxFolder

            # Create 'ReadOnly' element
            $readOnlyAttr = $xmlObj.CreateElement("ReadOnly")
            $readOnlyAttr.InnerText = $folder.readOnly

            # Append the 'HostFolder', 'SandboxFolder', and 'ReadOnly' elements to the 'MappedFolder' element
            $null = $mappedFolderElement.AppendChild($hostFolderAttr)
            $null = $mappedFolderElement.AppendChild($sandboxFolderAttr)
            $null = $mappedFolderElement.AppendChild($readOnlyAttr)

            # Append the 'MappedFolder' element to the 'MappedFolders' element
            $null = $mappedFoldersElement.AppendChild($mappedFolderElement)
        }

        $null = $configElement.AppendChild($mappedFoldersElement)
        break
    }
}

switch (($null -ne $configData.logonCommands)) {
    $true {
        # Create 'LogonCommand' element
        $logonCommandsElement = $xmlObj.CreateElement("LogonCommand")

        foreach ($logonCommand in  $configData.logonCommands) {
            # Create 'Command' element
            $commandElement = $xmlObj.CreateElement("Command")
            $commandElement.InnerText = $logonCommand

            # Append the 'Command' element to the 'LogonCommand' element.
            $null = $logonCommandsElement.AppendChild($commandElement)
        }

        $null = $configElement.AppendChild($logonCommandsElement)
        break
    }
}

# Append the 'MappedFolders' and 'LogonCommand' elements to the 'Configuration' element

# Append the 'Configuration' element to the root XML document
$null = $xmlObj.AppendChild($configElement)

$xmlWriterSettings = [System.Xml.XmlWriterSettings]@{
    "Indent"             = $true;
    "OmitXmlDeclaration" = $true;
}
$xmlWriterObj = [System.Xml.XmlWriter]::Create($configFileOutPath, $xmlWriterSettings)

$xmlObj.Save($xmlWriterObj)

$xmlWriterObj.Dispose()

return $xmlObj