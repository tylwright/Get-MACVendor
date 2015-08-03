# getMACVendor.ps1

## Description
This PowerShell script searches the IEEE's database of vendors/MAC addresses to find the vendor of your query (given MAC address).

## How to use
```
.\getMACVendor.ps1 -MAC 00:12:23
```
The script will output: *Pixim*

## Requirements
In order to use this script, please keep the file: *vendors.txt* in the same folder as the script.  This file contains the relationships between certain MAC addresses and vendors.  An up-to-date list can be obtained from here: <a href='http://standards-oui.ieee.org/oui.txt'>http://standards-oui.ieee.org/oui.txt</a>.

## Changelog
[August 3, 2015] [v0.1] - Script created
