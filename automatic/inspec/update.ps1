import-module au

$releases = 'https://downloads.chef.io/inspec'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url64bit\s*=\s*)('.*')"     = "`$1'$($Latest.URL64)'"          
            "(?i)(^\s*checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_GetLatest {

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $download_page = Invoke-WebRequest $releases

    if ($download_page.StatusCode -eq 200)
    {

        $re = '*/stable/*/windows/2016/inspec-*-x64.msi'
        $url = $download_page.Links | Where-Object href -like $re | Select-Object -ExpandProperty href
    
        $version = $url -split '\/' | select-object -index 6
        $url64   = $url
        return @{ URL64=$url64; Version = $version }
    }

}

Update-Package -ChecksumFor 64