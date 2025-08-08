Describe 'Debloat Windows script' {
    It 'removes specified apps' {
        $global:removed = @()
        function Get-AppxPackage { param([string]$Name,[switch]$AllUsers) @([pscustomobject]@{Name='Microsoft.BingNews'}) }
        function Get-AppxProvisionedPackage { param([switch]$Online) @([pscustomobject]@{PackageName='Microsoft.BingNews'}) }
        function Remove-AppxPackage { param([Parameter(ValueFromPipeline=$true)]$InputObject,[switch]$AllUsers,[Parameter(ValueFromRemainingArguments=$true)]$Args) process { $global:removed += ,$InputObject } }
        function Remove-AppxProvisionedPackage { param([Parameter(ValueFromPipeline=$true)]$InputObject,[switch]$Online,[Parameter(ValueFromRemainingArguments=$true)]$Args) process {} }
        $debloatPath = Join-Path (Join-Path $PSScriptRoot '..') 'Individual Scripts/Debloat Windows'
        $content = Get-Content -Path $debloatPath -Raw
        . ([ScriptBlock]::Create($content))
        $global:removed.Count | Should -BeGreaterThan 0
    }
}

Describe 'Remove Bloatware RegKeys script' {
    It 'removes bloatware registry keys' {
        $global:keys = @()
        function Remove-Item { param([Parameter(ValueFromPipeline=$true)]$Path,[switch]$Recurse) process { $global:keys += ,$Path } }
        $regPath = Join-Path (Join-Path $PSScriptRoot '..') 'Individual Scripts/Remove Bloatware RegKeys'
        $regContent = Get-Content -Path $regPath -Raw
        . ([ScriptBlock]::Create($regContent))
        $global:keys | Should -Contain 'HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y'
    }
}
