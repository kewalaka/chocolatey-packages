$ErrorActionPreference = 'Stop'

$packageName = 'sql2012-as-amo'
$url32       = 'https://download.microsoft.com/download/3/6/1/3610D28C-D02D-4663-A850-CB77A24A5361/ENU/x86/SQL_AS_AMO.msi'
$url64       = 'https://download.microsoft.com/download/3/6/1/3610D28C-D02D-4663-A850-CB77A24A5361/ENU/x64/SQL_AS_AMO.msi'
$checksum32  = '2E4159EB3DFE716D269DFBBFB9E48A6784BFC0383BCFDD8B89C67351430E6EAE'
$checksum64  = '599095ACB9E9B1DE50891426A648410AFC0549EC334412CBEACD226EF9EFC066'

# install both x86 and x64 editions of AMO since x64 supports both

# start with the 32bit version
$packageArgs = @{
  packageName  = $packageName
  fileType     = 'msi'
  silentArgs   = "/qn /log `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).install.log`""
  url          = $url32
  checksum     = $checksum32
  checksumType ='sha256'
  validExitCodes         = @(0)
}

Install-ChocolateyPackage @packageArgs

# Note - not possible to use Get-AppInstallLocation to confirm successful, because Microsft uses the same name for both the 32bit and 64bit versions

# 32bit DONE.

# only install the 64bit version if the system supports it
if (Get-ProcessorBits -eq 64) {
  $packageArgs['url'] = ''
  $packageArgs['url64bit'] = $url64
  $packageArgs['checksum64'] = $checksum64
  $packageArgs['checksumType64'] = 'sha256'
  $packageArgs['registryUninstallerKey'] = 'Microsoft SQL Server 2012 Analysis Management Objects (x64)'

  Install-ChocolateyPackage @packageArgs

  # Note - not possible to use Get-AppInstallLocation to confirm successful, because Microsft uses the same name for both the 32bit and 64bit versions
  # 64bit DONE.
