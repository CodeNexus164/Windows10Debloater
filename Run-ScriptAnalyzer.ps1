param(
    [string]$Path = $PSScriptRoot
)

$settings = Join-Path $PSScriptRoot 'PSScriptAnalyzerSettings.psd1'
Invoke-ScriptAnalyzer -Path $Path -Recurse -Settings $settings
