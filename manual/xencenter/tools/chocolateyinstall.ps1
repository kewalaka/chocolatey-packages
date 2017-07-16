$ErrorActionPreference = 'Stop';

$packageName= 'xencenter'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://downloadns.citrix.com.edgesuite.net/12637/XenServer-7.2.0-XenCenterSetup.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  silentArgs    = "/i /q /Log /LogFile `"$env:TEMP\chocolatey\$($packageName)\$($packageName).Install.log`""
  validExitCodes= @(0, 3010, 1641)

  softwareName  = 'Citrix XenCenter'
  checksum      = 'EED2AD46C7E89D6880DB83E4599864AF9C46607B8EFB760FF583A70332CAD63F'
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs