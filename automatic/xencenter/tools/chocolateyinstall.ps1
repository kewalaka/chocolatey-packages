$ErrorActionPreference = 'Stop'

$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName            = 'xencenter'
  fileType               = 'exe'
  url                    = ''
  url64bit               = 'http://downloadns.citrix.com.edgesuite.net/12637/XenServer-7.2.0-XenCenterSetup.exe'
  checksum               = ''
  checksum64             = 'EED2AD46C7E89D6880DB83E4599864AF9C46607B8EFB760FF583A70332CAD63F'
  checksumType           = 'sha256'
  checksumType64         = 'sha256'
  silentArgs             = "/i /q /Log /LogFile `"$env:TEMP\chocolatey\$($packageName)\$($packageName).Install.log`""
  validExitCodes         = @(0, 3010, 1641)
  softwareName           = 'xencenter*'
}
Install-ChocolateyPackage @packageArgs

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\$packageName.exe"
Write-Host "$packageName registered as $packageName"
