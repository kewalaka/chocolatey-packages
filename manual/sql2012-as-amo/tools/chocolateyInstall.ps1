$packageName = 'sql2012-as-amo'
$url32       = 'https://download.microsoft.com/download/3/6/1/3610D28C-D02D-4663-A850-CB77A24A5361/ENU/x86/SQL_AS_AMO.msi'
$url64       = 'https://download.microsoft.com/download/3/6/1/3610D28C-D02D-4663-A850-CB77A24A5361/ENU/x64/SQL_AS_AMO.msi'
$checksum32  = ''
$checksum64  = ''

# install both x86 and x64 editions of AMO since x64 supports both
$params = @{
  packageName  = $packageName;
  fileType     = 'msi';
  silentArgs   = '/qn /log `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).install.log`"';
  url          = $url32;
  checksum     = $checksum32
  checksumType ='sha256'
}

Install-ChocolateyPackage @params

# only install the 64bit version if the system supports it
if (Get-ProcessorBits -eq 64) {
  $params['url'] = ''
  $params['url64bit'] = $url64
  $params['checksum64'] = $checksum64
  $params['checksumType64'] = 'sha256'

  Install-ChocolateyPackage @params
}