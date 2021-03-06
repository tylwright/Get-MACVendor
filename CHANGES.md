# Changelog
All notable changes to this project will be documented in this file.

## [0.6] - 2019-05-07
### Changed
- #3 (Bug): Vendors with "," in their name weren't being returned correctly

## [0.5] - 2018-05-25
### Changed
- Get-MACVendor -Vendor <vendor name> now returns a nice table!
-- Table is grouped by vendor name (ex. MACs pertaining to Dell and Dell Inc. will be returned but grouped into separate tables.)
- Readme updated to show actual output of commands

## [0.4] - 2018-05-15
### Added
- New feature!  Get-MACVendor -Vendor <vendor name> to return MACs registered to given vendor

### Changed
- Configuring Travis CI build to align with Pester's Travis CI config

## [0.3] - 2018-05-12
### Added
- Allow users to enter MAC w/out ':' or '-'
- Added unit tests and Travis CI build
- Added proper doc to module function

### Changed
- Created an actual changelog
- Name now follows PS naming standards: getMACVendor --> Get-MACVendor
- Output is now '<name of vendor>' instead of 'The vendor is: <name of vendor>'
- Changed output when updating vendor list to Write-Host instead of Write-Debug
- Only allow one parameter at a time (-MAC or -Action)
- Converted script into a module

## [0.2] - 2015-09-16
### Added
- Added ability to update OUI list

### Changed
- Various bug fixes

## [0.1] - 2015-08-03
### Added
- Ability to pass in a MAC and return vendor
