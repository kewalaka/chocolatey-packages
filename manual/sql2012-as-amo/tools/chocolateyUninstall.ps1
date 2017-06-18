$ErrorActionPreference = 'Stop'
 
$packageName = 'sql2012-as-amo'

$softwareNamePattern = 'Microsoft SQL Server 2012 Analysis Management Objects'


# 32 bit uninstaller 
[array] $key = Get-UninstallRegistryKey $softwareNamePattern
if ($key.Count -eq 1) {
    $key | % {
        $packageArgs = @{
            packageName    = $packageName
            silentArgs     = ''
            fileType       = 'MSI'
            validExitCodes = @(0)
            file           = ''
        }
        Uninstall-ChocolateyPackage @packageArgs
    }
}
elseif ($key.Count -eq 0) {
    Write-Warning "$packageName (32bit) has already been uninstalled by other means."
}
elseif ($key.Count -gt 1) {
    Write-Warning "$key.Count matches found!"
    Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
    Write-Warning "Please alert package maintainer the following keys were matched:"
    $key | % {Write-Warning "- $_.DisplayName"}
}


# 64 bit uninstaller
if (Get-ProcessorBits -eq 64) {

    $softwareNamePattern = 'Microsoft SQL Server 2012 Analysis Management Objects (x64)'
    
    [array] $key = Get-UninstallRegistryKey $softwareNamePattern
    if ($key.Count -eq 1) {
        $key | % {
            $packageArgs = @{
                packageName    = $packageName
                silentArgs     = ''
                fileType       = 'MSI'
                validExitCodes = @(0)
                file           = ''
            }
            Uninstall-ChocolateyPackage @packageArgs
        }
    }
    elseif ($key.Count -eq 0) {
        Write-Warning "$packageName (64bit) has already been uninstalled by other means."
    }
    elseif ($key.Count -gt 1) {
        Write-Warning "$key.Count matches found!"
        Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
        Write-Warning "Please alert package maintainer the following keys were matched:"
        $key | % {Write-Warning "- $_.DisplayName"}
    }
}
