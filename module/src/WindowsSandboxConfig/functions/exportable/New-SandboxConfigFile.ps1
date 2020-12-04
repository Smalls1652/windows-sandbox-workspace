function New-SandboxConfigFile {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$ConfigName = "Primary"
    )

    $configsDirPath = [System.IO.Path]::Combine($modulePath, ".configs\")

    $configFileOutPath = [System.IO.Path]::Combine($modulePath, "$($ConfigName).wsb")

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
                $folder.hostFolder = Invoke-SandboxParseVariable -InputData $folder.hostFolder

                $folder.sandboxFolder = Invoke-SandboxParseVariable -InputData $folder.sandboxFolder

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
                $logonCommand = Invoke-SandboxParseVariable -InputData $logonCommand

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

    switch (($null -ne $configData.networking)) {
        $true {
            $networkingElement = $xmlObj.CreateElement("Networking")

            switch ($configData.networking) {
                $true {
                    $null = $networkingElement.InnerText = "Default"
                    break
                }

                Default {
                    $null = $networkingElement.InnerText = "Disable"
                    break
                }
            }

            $null = $configElement.AppendChild($networkingElement)
            break
        }
    }

    switch (($null -ne $configData.vGpu)) {
        $true {
            $vGpuElement = $xmlObj.CreateElement("vGPU")

            switch ($configData.vGpu) {
                $true {
                    $null = $vGpuElement.InnerText = "Enable"
                    break
                }

                Default {
                    $null = $vGpuElement.InnerText = "Disable"
                    break
                }
            }

            $null = $configElement.AppendChild($vGpuElement)
            break
        }
    }

    switch (($null -ne $configData.audioInput)) {
        $true {
            $audioInputElement = $xmlObj.CreateElement("AudioInput")

            switch ($configData.audioInput) {
                $true {
                    $null = $audioInputElement.InnerText = "Enable"
                    break
                }

                Default {
                    $null = $audioInputElement.InnerText = "Disable"
                    break
                }
            }

            $null = $configElement.AppendChild($audioInputElement)
            break
        }
    }

    switch (($null -ne $configData.videoInput)) {
        $true {
            $videoInputElement = $xmlObj.CreateElement("VideoInput")

            switch ($configData.videoInput) {
                $true {
                    $null = $videoInputElement.InnerText = "Enable"
                    break
                }

                Default {
                    $null = $videoInputElement.InnerText = "Disable"
                    break
                }
            }

            $null = $configElement.AppendChild($videoInputElement)
            break
        }
    }

    switch (($null -ne $configData.protectedClient)) {
        $true {
            $protectedClientElement = $xmlObj.CreateElement("ProtectedClient")

            switch ($configData.protectedClient) {
                $true {
                    $null = $protectedClientElement.InnerText = "Enable"
                    break
                }

                Default {
                    $null = $protectedClientElement.InnerText = "Disable"
                    break
                }
            }

            $null = $configElement.AppendChild($protectedClientElement)
            break
        }
    }

    switch (($null -ne $configData.printerRedirection)) {
        $true {
            $printerRedirectionElement = $xmlObj.CreateElement("PrinterRedirection")

            switch ($configData.printerRedirection) {
                $true {
                    $null = $printerRedirectionElement.InnerText = "Enable"
                    break
                }

                Default {
                    $null = $printerRedirectionElement.InnerText = "Disable"
                    break
                }
            }

            $null = $configElement.AppendChild($printerRedirectionElement)
            break
        }
    }

    switch (($null -ne $configData.clipboardRedirection)) {
        $true {
            $clipboardRedirectionElement = $xmlObj.CreateElement("ClipboardRedirection")

            switch ($configData.clipboardRedirection) {
                $true {
                    $null = $clipboardRedirectionElement.InnerText = "Default"
                    break
                }

                Default {
                    $null = $clipboardRedirectionElement.InnerText = "Disable"
                    break
                }
            }

            $null = $configElement.AppendChild($clipboardRedirectionElement)
            break
        }
    }

    switch (($null -ne $configData.memoryInMB)) {
        $true {
            $memoryInMBElement = $xmlObj.CreateElement("MemoryInMB")
            $memoryInMBElement.InnerText = $configData.memoryInMB

            $null = $configElement.AppendChild($memoryInMBElement)
            break
        }
    }

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
}