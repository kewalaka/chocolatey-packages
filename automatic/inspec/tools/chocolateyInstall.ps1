
$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName   = 'inspec'
  fileType      = 'MSI'
  url64bit      = 'https://packages.chef.io/files/stable/inspec/2.1.43/windows/2016/inspec-2.1.43-1-x64.msi'
  checksum64    = '3fbfa46421d5632992c29f0b3d1357ef5b7870e4c851c2b4a0a7bfdf4165370d'
  checksumType64= 'sha256'
  silentArgs    = "/qn"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs


















