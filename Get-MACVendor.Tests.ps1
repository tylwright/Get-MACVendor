Import-Module -Name ./Get-MACVendor.psm1 -Force -ErrorAction Stop

# Test inputs in various formats and responses
Describe "Get-MACVendor -MAC" {
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
}

Describe "Get-MACVendor -Vendor" {
    Context "Check acceptable inputs and returned results" {
        It "Allows iRobot and returns one result" {
            $results = Get-MACVendor -Vendor iRobot
            $results | Should -Contain "1 result`r`n"
            $results | Out-String | Should -BeLike "*50-14-79*"
        }
        It "Allows Dell and returns many results" {
            $results = Get-MACVendor -Vendor Dell
            $results | Out-String | Should -BeLike "*results`r`n*"
            $results | Out-String | Should -BeLike "*EC-F4-BB*"
        }
    }
}

Describe "Get-MACVendor -Action" {
    Context "Check OUI actions" {
        It "Updates OUI" {
            {Get-MACVendor -Action Update} | Should -Not -Throw
        }
    }
}