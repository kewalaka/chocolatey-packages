$packageName = 'monogodb.install'
# Allow the user to specify the data and log path, falling back to sensible defaults
$pp = Get-PackageParameters
if(!$pp['dataPath']) { 
    $pp['dataPath'] = "$env:PROGRAMDATA\MongoDB\data\db"
}
if(!$pp['logPath']) { 
    $pp['logPath'] = "$env:PROGRAMDATA\MongoDB\log"
}
# should MongoDB be installed as a Windows Service
if(!$pp['registerWindowsService']) { 
    $pp['registerWindowsService'] = $true
}
# should Compass be installed - as of 3.6.5 the MSI is not working if this is selected
if(!$pp['installCompass']) { 
    $pp['installCompass'] = $false
}
if($pp['installCompass']) {$shouldInstallCompass = 1} else {$shouldInstallCompass = 0}

# enable MSI logging to find where Mongo installs itself
$InstallLog = "$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).install.log"

$silentArgs = "/quiet /qn /norestart /log `"$InstallLog`" SHOULD_INSTALL_COMPASS=$shouldInstallCompass"

$packageArgs = @{
    packageName   = "$packageName"
    fileType      = 'MSI'
    url64bit      = 'https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-3.6.5-signed.msi'
    checksum64    = 'f1e31e6ad01cd852d0a59dacf9b2ea34e64fb61977f9334338e9f16a468dec92'
    checksumType64= 'sha256'
    silentArgs    = $silentArgs
    validExitCodes= @(0, 3010)
}

Install-ChocolateyPackage @packageArgs

# find where Mongo installed itself from the MSI log - crazy, but true
$InstallPath = $((Get-Content $InstallLog | Select-String 'INSTALLLOCATION =') -split " = ")[1]
Write-Output "MongoDB installed to $InstallPath"

if ($pp['registerWindowsService'])
{
    New-Item -ItemType Directory $pp['dataPath'] -ErrorAction SilentlyContinue
    New-Item -ItemType Directory $pp['logPath'] -ErrorAction SilentlyContinue
   
    $configFilePath = "$InstallPath\mongod.cfg"

    # don't overwrite the config file if it already exists
    if (!(Test-Path $configFilePath))
    {
        # put the parameters into vars so I can insert them into $configFile herestring
        $dataPath = $pp['dataPath']
        $logPath = $pp['logPath']
        
        $configFile = @"
systemLog:
    quiet: true
    destination: file
    path: $logPath\mongod.log
    logAppend: true
    logRotate: reopen
storage:
    dbPath: $dataPath
    directoryPerDB: true
"@

        Add-Content -Path $configFilePath -Value $configFile
    }    

    # register MongoDB server as a Windows Service
    & "$InstallPath\bin\mongod.exe" --config "$InstallPath\mongod.cfg" --install
    # start the service
    Start-Service -Name MongoDB

}
