$ErrorActionPreference = 'Stop';

$packageName= 'xencenter'

$packageArgs = @{
  packageName            = $packageName
  fileType               = 'EXE'
  url64bit               = 'http://downloadns.citrix.com.edgesuite.net/12637/XenServer-7.2.0-XenCenterSetup.exe'
  checksum64             = 'EED2AD46C7E89D6880DB83E4599864AF9C46607B8EFB760FF583A70332CAD63F'
  checksumType64         = 'sha256'
  silentArgs             = "/i /q /Log /LogFile `"$env:TEMP\chocolatey\$($packageName)\$($packageName).Install.log`""
  validExitCodes         = @(0, 3010, 1641)
  softwareName           = 'Citrix XenCenter'
}

Install-ChocolateyPackage @packageArgs
