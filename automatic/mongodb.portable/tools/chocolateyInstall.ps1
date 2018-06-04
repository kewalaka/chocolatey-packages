$packageName = 'mongodb.portable'

$packageArgs = @{
  packageName   = "$packageName"
  fileType      = 'MSI'
  url64bit      = 'http://downloads.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-3.6.5.zip'
  checksum64    = '3546f8d5721e91c9158133d37335d35703207af566266b248eeba6ed0db0fbc0'
  checksumType64= 'sha256'
  silentArgs    = $silentArgs
  validExitCodes= @(0, 3010)
}

Write-Verbose "Default install location is `'$env:ChocolateyToolsLocation`'"
$binRoot = Get-ToolsLocation

Write-Debug "Process package parameters."
$pp = Get-PackageParameters
# where should Mongo be installed
if(!$pp['installDir']) { 
  $pp['installDir'] = $binRoot
}

Write-Debug "Installing to `'$binRoot`'"
$mongoPath = Join-Path $binRoot $packageName
$mongoBin = Join-Path $mongoPath 'bin'

$mongoDaemon = Join-Path $mongoBin 'mongod.exe'
if (Test-Path $mongoDaemon){
  Start-ChocolateyProcessAsAdmin "& $mongoDaemon --remove"
  if (Test-Path $mongoPath) {Remove-Item $mongoPath -Recurse -Force}
}

Install-ChocolateyPackage @packageArgs

$extractPath = Join-Path $binRoot $fileName                             
Rename-Item -Path $extractPath `
            -NewName $packageName `
            -Force

Install-ChocolateyPath $mongoBin 'Machine'

# setup mongo working dirs
$dataDir = Join-Path $mongoPath 'data'
if (!$(Test-Path $dataDir)) {mkdir $dataDir}
$logDir = Join-Path $mongoPath 'log'
if (!$(Test-Path $logDir)){mkdir $logDir}

# create batch files
$exeFile = Join-Path $mongoBin 'mongo.exe'
$batchFile = Join-Path $mongoBin 'mongo.bat'
"@echo off
$exeFile %*" | Out-File $batchFile -encoding ASCII
$batchFile = Join-Path $mongoBin 'mongorotatelogs.bat'
"@echo off
$exeFile --eval `'db.runCommand(`"logRotate`")`' mongohost:27017/admin" | Out-File $batchFile -encoding ASCII

# start mongodb as a Windows service
$logFile = Join-Path $logDir "MongoDB.log"
$installArgs = "$mongoDaemon --quiet --bind_ip 127.0.0.1 --logpath $logFile --logappend --dbpath $dataDir --directoryperdb --install; net start `"MongoDB`""
Start-ChocolateyProcessAsAdmin -Statements "$installArgs"
