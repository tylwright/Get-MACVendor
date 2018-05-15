# Get-MACVendor
[![Build Status](https://travis-ci.org/tylwright/Get-MACVendor.svg?branch=master)](https://travis-ci.org/tylwright/Get-MACVendor)

## Description
This PowerShell module searches the IEEE's database of vendors/MAC addresses to find the vendor of your query (given MAC address).  As of v0.4, you can also find MACs registered to a vendor.

## How to use
```
Import-Module ./Get-MACVendor.psm1

Get-MACVendor -MAC 00:12:23
Get-MACVendor -MAC 00-12-23
Get-MACVendor -MAC 001223
Get-MACVendor -MAC 00:12:23:45:54:32

Get-MACVendor -Vendor Dell
Get-MACVendor -Vendor iRobot
```
The script will output: *Pixim*

## Downloading/Updating the OUI list
```
Get-MACVendor -Action Update
```
The module will pull a fresh version of the OUI list from <a href='http://standards-oui.ieee.org/oui.txt'>http://standards-oui.ieee.org/oui.txt</a>.

## Requirements
In order to use this module, please keep the file *vendors.txt* in the same directory.  This file contains the relationships between certain MAC addresses and vendors.  You may update the file with: `Get-MACVendor -Action Update`.

### Unit Tests
In order to perform unit tests, you'll need Pester.
```
Install-Module -Name Pester -Force -SkipPublisherCheck
Invoke-Pester
```
