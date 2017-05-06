$packageName = 'tableaureader'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'EXE' #only one of these: exe, msi, msu

  softwareName  = 'Tableau Reader*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
  url   = 'https://downloads.tableau.com/tssoftware/TableauReader-32bit-10-2-1.exe'
  url64 = 'https://downloads.tableau.com/tssoftware/TableauReader-64bit-10-2-1.exe'

  checksum      = ''
  checksumType  = 'sha256'
  checksum64    = ''
  checksumType64= 'sha256'
  silentArgs    = "/install /quiet /norestart /log `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).install.log`" ACCEPTEULA=1"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs
