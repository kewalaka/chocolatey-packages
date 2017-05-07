$ErrorActionPreference = 'Stop'

# getting the latest version via bintray

$base_uri = 'https://api.bintray.com'
$account = $repository = 'cryptomator'
$package = 'cryptomator-win'
$url = "$base_uri/packages/$account/$repository/$package" + "?attribute_values=1"
$packageDetails = Invoke-WebRequest $url
if ($packageDetails.StatusCode -eq 200)
{
  # use regex to only select versions that include 3 groups of digits separated by dots (this avoids releases that end with -rc or similiar)
  $regex = '^(\d+\.)?(\d+\.)?(\*|\d+)$'
  # get the latest version that matches
  $version = ($packageDetails.Content | ConvertFrom-Json).Versions | where {$_ -match $regex} | select -first 1
}

$packageName = 'cryptomator'
$url32       = ''
$url64       = ''
$checksum32  = ''
$checksum64  = ''
 
$packageArgs = @{
  packageName            = $packageName
  fileType               = 'msi'
  url                    = $url32
  url64bit               = $url64
  checksum               = $checksum32
  checksum64             = $checksum64
  checksumType           = 'sha256'
  checksumType64         = 'sha256'
  silentArgs             = "/qn INSTALLLEVEL=3 /log `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).install.log`""
  validExitCodes         = @(0)
  registryUninstallerKey = 'FME Desktop'
}
Install-ChocolateyPackage @packageArgs
 
$installLocation = Get-AppInstallLocation $packageArgs.registryUninstallerKey
if ($installLocation)  {
    Write-Host "$packageName installed to '$installLocation'"
}
else { Write-Warning "Can't find $PackageName install location" }

