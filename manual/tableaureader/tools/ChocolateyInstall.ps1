$ErrorActionPreference = 'Stop'

$packageName = 'tableaureader'
$url32       = 'https://downloads.tableau.com/tssoftware/TableauReader-32bit-10-2-1.exe'
$url64       = 'https://downloads.tableau.com/tssoftware/TableauReader-64bit-10-2-1.exe'
$checksum32  = ''
$checksum64  = '22C8B4E3C19C1EFC787280F93B63EC9873550021CE22E8EC8D8ECF5223D67574'

$packageArgs = @{
  packageName            = $packageName
  fileType               = 'msi'; #only one of these: exe, msi, msu
  silentArgs             = "/install /quiet /norestart /log `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).install.log`" ACCEPTEULA=1"
  url                    = $url32
  url64bit               = $url64
  checksum               = $checksum32
  checksum64             = $checksum64
  checksumType           = 'sha256'
  checksumType64         = 'sha256'
  validExitCodes         = @(0, 3010, 1641)
  registryUninstallerKey = 'Tableau Reader*'
}

Install-ChocolateyPackage @params

$installLocation = Get-AppInstallLocation $packageArgs.registryUninstallerKey
if ($installLocation)  {
    Write-Host "$packageName installed to '$installLocation'"
}
else { Write-Warning "Can't find $PackageName install location" }
