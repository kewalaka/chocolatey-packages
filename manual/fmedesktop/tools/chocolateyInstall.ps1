$ErrorActionPreference = 'Stop'

$packageName = 'fmedesktop'
$url32       = 'https://downloads.safe.com/fme/2017/fme-desktop-2017.0-b17288-win-x86.msi'
$url64       = 'https://downloads.safe.com/fme/2017/fme-desktop-2017.0-b17288-win-x64.msi'
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
  silentArgs             = "/VERYSILENT /qn INSTALLLEVEL=3 /log `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).install.log`""
  validExitCodes         = @(0)
  registryUninstallerKey = 'FME Desktop'
}
Install-ChocolateyPackage @packageArgs
 
$installLocation = Get-AppInstallLocation $packageArgs.registryUninstallerKey
if ($installLocation)  {
    Write-Host "$packageName installed to '$installLocation'"
}
else { Write-Warning "Can't find $PackageName install location" }

