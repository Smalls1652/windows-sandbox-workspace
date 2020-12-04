function Update-SandboxInternalVariables {
    [CmdletBinding()]
    param(

    )

    $Script:privateShareFolderPath = [System.IO.Path]::Combine($Script:workspacePath, "private-share\")
    $Script:publicShareFolderPath = [System.IO.Path]::Combine($Script:workspacePath, "public-share\")

    $Script:variableMappings = @(
        [LibWindowsSandbox.Models.ConfigVariable]@{
            "VariableName" = "DefaultPrivateShare";
            "Content"      = ($privateShareFolderPath.Substring(0, ($privateShareFolderPath.Length - 1)));
        },
        [LibWindowsSandbox.Models.ConfigVariable]@{
            "VariableName" = "DefaultPublicShare";
            "Content"      = ($publicShareFolderPath.Substring(0, ($publicShareFolderPath.Length - 1)));
        },
        [LibWindowsSandbox.Models.ConfigVariable]@{
            "VariableName" = "SandboxUserProfile";
            "Content"      = "C:\Users\WDAGUtilityAccount"
        },
        [LibWindowsSandbox.Models.ConfigVariable]@{
            "VariableName" = "SandboxDesktop";
            "Content"      = "C:\Users\WDAGUtilityAccount\Desktop"
        },
        [LibWindowsSandbox.Models.ConfigVariable]@{
            "VariableName" = "UserProfile";
            "Content"      = $env:USERPROFILE;
        }
    )
}