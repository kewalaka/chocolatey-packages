$ErrorActionPreference = 'Stop'

$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName            = 'xencenter'
  fileType               = 'exe'
  url                    = 'http://downloadns.citrix.com.edgesuite.net/12637/XenServer-7.2.0-XenCenterSetup.exe'
  url64bit               = ''
  checksum               = 'eed2ad46c7e89d6880db83e4599864af9c46607b8efb760ff583a70332cad63f'
  checksum64             = ''
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
