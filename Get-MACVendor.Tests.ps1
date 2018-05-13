Import-Module -Name ./Get-MACVendor.psm1 -Force -ErrorAction Stop

# Test inputs in various formats and responses
Describe "Get-MACVendor" {
    Context "Check acceptable inputs and returned results" {
        It "Allows 001223 and returns Pixim" {
            Get-MACVendor -MAC 001223 | Should -Be 'Pixim'
        }
        It "Allows 00:12:23 and returns Pixim" {
            Get-MACVendor -MAC 00:12:23 | Should -Be 'Pixim'
        }
        It "Allows 00-12-23 and returns Pixim" {
            Get-MACVendor -MAC 00-12-23 | Should -Be 'Pixim'
        }
        It "Allows 001223444444 and returns Pixim" {
            Get-MACVendor -MAC 001223444444 | Should -Be 'Pixim'
        }
    }
    Context "Check unacceptable inputs" {
        It "Does not allow 0012" {
            {Get-MACVendor -MAC 0012} | Should -Throw
        }
    }
    Context "Check OUI actions" {
        It "Updates OUI" {
            {Get-MACVendor -Action Update} | Should -Not -Throw
        }
    }
}  