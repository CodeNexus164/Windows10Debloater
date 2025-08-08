Describe 'DebloatAll' {
    BeforeAll {
        function DebloatAll {
            $WhitelistedApps = 'Microsoft.WindowsCalculator'
            $NonRemovable = 'DoNotMatch'
            Get-AppxPackage -AllUsers | Where-Object { $_.Name -NotMatch $WhitelistedApps -and $_.Name -NotMatch $NonRemovable } | Remove-AppxPackage
            Get-AppxPackage | Where-Object { $_.Name -NotMatch $WhitelistedApps -and $_.Name -NotMatch $NonRemovable } | Remove-AppxPackage
            Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -NotMatch $WhitelistedApps -and $_.PackageName -NotMatch $NonRemovable } | Remove-AppxProvisionedPackage -Online
        }
        function Get-AppxPackage {}
        function Get-AppxProvisionedPackage { param([switch]$Online) }
        function Remove-AppxPackage { param([Parameter(ValueFromPipeline=$true)]$InputObject) }
        function Remove-AppxProvisionedPackage { param([Parameter(ValueFromPipeline=$true)]$InputObject,[switch]$Online) }
    }

    It 'removes only non-whitelisted apps' {
        Mock -CommandName Get-AppxPackage -MockWith {
            @(
                [pscustomobject]@{ Name = 'Microsoft.WindowsCalculator' },
                [pscustomobject]@{ Name = 'Contoso.Bloatware' }
            )
        }
        Mock -CommandName Get-AppxProvisionedPackage -MockWith { @() }
        Mock -CommandName Remove-AppxPackage -MockWith {}
        Mock -CommandName Remove-AppxProvisionedPackage -MockWith {}

        DebloatAll

        Assert-MockCalled Remove-AppxPackage -ParameterFilter { $InputObject.Name -eq 'Contoso.Bloatware' } -Times 2
        Assert-MockCalled Remove-AppxPackage -ParameterFilter { $InputObject.Name -eq 'Microsoft.WindowsCalculator' } -Times 0
    }
}
