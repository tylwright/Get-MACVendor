[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    [string]$MAC

    #[Parameter(Mandatory=$False)]
    #[String]$vendorList
)

# Default location for vendor list
$vendorList = "$pwd/vendor.txt"

# Clean MAC
function Clean-MAC{
    # Change : to -
    $MAC = $MAC -replace ":","-"
    
    # Only use the first 00:00:00 character
    if($MAC.length -lt 7){
        $MAC = $MAC.Substring(0, 8)
    }
    return $MAC
}

# Get updated list from IEEE
#function Get-VendorList{
    #$client = New-Object System.Net.WebClient
    #$url = "http://standards-oui.ieee.org/oui.txt"
    #$storeAs = "$pwd/vendor.txt"
    #$client.DownloadFile($url, $storeAs)
#}

# Search vendor list for match
function Get-Vendor{
    [cmdletbinding()]
    Param(
        [string]$MAC
    )
    Process{
        Try{
            $output = Select-String -Path "$pwd/vendor.txt" -pattern $MAC
            $output = $output -replace ".*(hex)"
            $output = $output.Substring(3)
            return $output
        }
        Catch{
            "MAC address was not found"
        }
    }
}

function Get-MAC{
    $MAC = Get-WmiObject win32_networkadapterconfiguration | SELECT macaddress
    $MAC = $MAC.macaddress
    foreach($address in $MAC){
        Get-Vendor(Clean-MAC($address))
    }
}

# Main
Get-Vendor(Clean-MAC($MAC))