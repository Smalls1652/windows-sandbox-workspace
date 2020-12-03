[CmdletBinding()]
param(

)

<#

|| Schema for settings ||

@{
    "Path" = "";
    "Name" = "";
    "Value" = 0;
    "Type" = ""
}

#>

Write-Verbose "Applying Microsoft Edge settings"

$settingsToSet = @(
    @{
        "Path"         = "HKLM:\SOFTWARE\Policies\Microsoft\Edge";
        "Name"         = "AutoImportAtFirstRun";
        "Value"        = 4;
        "PropertyType" = "Dword"
    },
    @{
        "Path"         = "HKLM:\SOFTWARE\Policies\Microsoft\Edge";
        "Name"         = "HideFirstRunExperience";
        "Value"        = 1;
        "PropertyType" = "Dword"
    },
    @{
        "Path"         = "HKLM:\SOFTWARE\Policies\Microsoft\Edge";
        "Name"         = "ForceSync";
        "Value"        = 0;
        "PropertyType" = "Dword"
    },
    @{
        "Path"         = "HKLM:\SOFTWARE\Policies\Microsoft\Edge";
        "Name"         = "SyncDisabled";
        "Value"        = 1;
        "PropertyType" = "Dword"
    },
    @{
        "Path"         = "HKLM:\SOFTWARE\Policies\Microsoft\Edge";
        "Name"         = "BrowserSignIn";
        "Value"        = 0;
        "PropertyType" = "Dword"
    },
    @{
        "Path"         = "HKLM:\SOFTWARE\Policies\Microsoft\Edge";
        "Name"         = "NewTabPageAllowedBackgroundTypes";
        "Value"        = 3;
        "PropertyType" = "Dword"
    },
    @{
        "Path"         = "HKLM:\SOFTWARE\Policies\Microsoft\Edge";
        "Name"         = "NewTabPageHideDefaultTopSites";
        "Value"        = 1;
        "PropertyType" = "Dword"
    }
)

foreach ($setting in $settingsToSet) {
    if ($PSCmdlet.ShouldProcess($setting['Path'], "Create property, $($setting['name']), with value: $($setting['value'])")) {
        
        switch (Test-Path -Path $setting['Path']) {
            $false {
                Write-Warning "Creating key path for '$($setting['Path'])."
                $null = New-Item -Path $setting['Path'] -Force
                break
            }
        }

        $null = New-ItemProperty @setting -Force
    }
}