$params = @{
  packageName = 'sql2012.amo';
  fileType = 'msi';
  silentArgs = '/quiet';
  url = 'https://download.microsoft.com/download/3/6/1/3610D28C-D02D-4663-A850-CB77A24A5361/ENU/x86/SQL_AS_AMO.msi';
  checksum=''
  checksumType='Sha256'
}

Install-ChocolateyPackage @params

# install both x86 and x64 editions of SMO since x64 supports both
if (Get-ProcessorBits -eq 64) {
  $params['url'] = ''
  $params['url64'] = 'https://download.microsoft.com/download/3/6/1/3610D28C-D02D-4663-A850-CB77A24A5361/ENU/x64/SQL_AS_AMO.msi'
  $params['checksum64'] = ''
  $params['checksumType64'] = 'Sha256'
  Install-ChocolateyPackage @params
}