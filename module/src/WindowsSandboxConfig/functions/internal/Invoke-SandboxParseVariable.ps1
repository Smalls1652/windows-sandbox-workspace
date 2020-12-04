function Invoke-SandboxParseVariable {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory)]
        [string]$InputData
    )

    $variableRegex = [System.Text.RegularExpressions.Regex]::new("(?'variableObject'{{\s(?'variableName'.+?)\s}})")

    $inputModified = $InputData

    $variableRegexMatches = $variableRegex.Matches($inputModified)

    foreach ($foundVariable in $variableRegexMatches) {
        $replacementContent = ($Script:variableMappings | Where-Object { $PSItem.VariableName -eq ($foundVariable.Groups['variableName'].Value) }).Content
        $inputModified = $inputModified -replace $foundVariable.Value, $replacementContent
    }

    return $inputModified
}