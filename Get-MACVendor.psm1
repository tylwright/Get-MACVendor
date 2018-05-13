<#
	Author: Tyler Wright
	Git Repo: https://github.com/tylwright/Get-MACVendor

	.Synopsis
	Shows the vendor who owns a MAC address prefix

	.Parameter MAC
	MAC address you wish to lookup the vendor of

	.Parameter Action
	An action you wish to perform
	Available Actions:
		Update: Updates MAC vendor list

	.Example
	# Update MAC vendor list
	Get-MACVendor -Action Update

	.Example
	# Display the vendor who owns a certain MAC address prefix
	Get-MACVendor -MAC 001223
	or
	Get-MACVendor -MAC 00:12:23
	or
	Get-MACVendor -MAC 00-12-23
#>

function Get-MACVendor 
{
	#region Script Arguments
	[CmdletBinding(DefaultParameterSetName='MACProvided')]
	param
	(
		[Parameter(Mandatory = $true,
				ParameterSetName = 'MACProvided',
				HelpMessage = 'MAC Address in any format')]
		[ValidateNotNullOrEmpty()]
		[string]$MAC,
		[Parameter(Mandatory = $true,
				ParameterSetName = 'UpdateRequested',
				HelpMessage = 'Actions available: Update')]
		[ValidateSet('update', IgnoreCase = $true)]
		[string]$action
	)
	#endregion

	#region Variables
	# Default location for vendor list
	$vendorList = "$pwd/vendor.txt"
	#endregion

	#region Functions
	<#
		.SYNOPSIS
			Updates vendor/MAC list
		
		.DESCRIPTION
			Retrieves a list of vendors and their assigned MAC addresses from  standards-oui.ieee.org/oui.txt.
	#>
	function Update-VendorList
	{
		Try
		{
			# If a vendor list already exists, rename it as "old"
			if (Test-Path $vendorList)
			{
				# In the event that an old copy of the OUI list was not deleted, delete it now before a new backup is made
				if (Test-Path "$vendorList.old")
				{
					Remove-Item -Path "$vendorList.old"
				}
				Rename-Item -Path $vendorList "$vendorList.old"
			}
			# Download vendor list
			Write-Host "Attempting to download a new OUI list..."
			$webclient = New-Object System.Net.WebClient
			$url = "http://standards-oui.ieee.org/oui.txt"
			$webclient.DownloadFile($url, $vendorList)
			# If vendor list downloaded successfully, delete the "old" copy
			if (Test-Path $vendorList)
			{
				Write-Host "Vendor list has been updated - deleting older version."
				Remove-Item -Path "$vendorList.old"
			}
		}
		Catch
		{
			Write-Host "Unable to download the latest OUI list from http://standards-oui.ieee.org"
			Write-Host "Reverting to previous OUI list..."
			# Rename the "old" copy back to the default name.
			# We want to be able to use this script even if our update function fails.
			Rename-Item "$vendorList.old" $vendorList
		}
	}

	<#
		.SYNOPSIS
			Makes sure that the given MAC is formatted correctly
		
		.DESCRIPTION
			First, the function removes any ":" or "-" characters from the MAC address.
			Second, the function limits the number of characters down to the first eight characters (vendors are only assigned the first three sections in a MAC address).
		
		.PARAMETER MAC
			Provide a MAC address in string format
	#>
	function Clean-MAC
	{
		param
		(
			[Parameter(Mandatory = $true,
					HelpMessage = 'Provide a MAC address in string format')]
			[ValidateNotNullOrEmpty()]
			[string]$MAC
		)
		
		# Change : to -
		$MAC = $MAC -replace ":", "-"

		if ($MAC -notlike '*-*')
		{
			$MAC = ($MAC -replace '(..)','$1-').trim('-')
		}
		
		# Only use the first 00:00:00 character
		if ($MAC.length -gt 7)
		{
			$MAC = $MAC.Substring(0, 8)
		}
		
		return $MAC
	}

	<#
		.SYNOPSIS
			Finds the vendor of a given MAC address
		
		.DESCRIPTION
			Searches for the given MAC address in the OUI list and returns the name of the vendor
		
		.PARAMETER MAC
			Provide a MAC address that has undergone the Clean-MAC function
	#>
	function Get-Vendor
	{
		[CmdletBinding()]
		param
		(
			[Parameter(Mandatory = $true,
					HelpMessage = 'Provide a MAC address that has undergone the Clean-MAC function')]
			[ValidateLength(8, 8)]
			[ValidateNotNullOrEmpty()]
			[string]$MAC
		)
		
		Process
		{
			Try
			{
				$output = Select-String -Path $vendorList -pattern $MAC
				$output = $output -replace ".*(hex)"
				$output = $output.Substring(3)
				return $output
			}
			Catch
			{
				Write-Warning "MAC address was not found"
			}
		}
	}
	#endregion

	#region Main Program
	# If the user wants to update the vendor list, direct them away from the vendor search
	if ($action.ToLower() -eq "update")
	{
		Update-VendorList
	}
	else
	{
		# Clean and format the given MAC address
		$cleanedMAC = Clean-MAC -MAC $MAC
		
		# Get the vendor of the MAC address
		$vendor = Get-Vendor -MAC $cleanedMAC
		
		# If there is a vendor, output the name
		if ($vendor)
		{
			Write-Output $vendor
		}
		else
		{
			Write-Output "Unable to find the vendor of $MAC."
		}
	}
	#endregion
	Export-ModuleMember -Function Get-MACVendor
}
