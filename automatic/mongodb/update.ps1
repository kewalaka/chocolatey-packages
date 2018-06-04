import-module au

$releases = 'https://www.mongodb.com/download-center?jmp=nav#community'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            # "(?i)(^\s*url64bit\s*=\s*)('.*')"     = "`$1'$($Latest.URL64)'"          
            # "(?i)(^\s*checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_GetLatest {

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    # invoke-webrequest is too slow
    $download_page = Invoke-RestMethod $releases

    if ($download_page -ne $null)
    {

        Write-Verbose "Parsing webpage looking for links to new release"
        $download_page -match 'href="([^"]*msi/download)"'
        $link = $Matches[1]
        # the link coms back looking like this:
        # /dr/fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-3.6.5-signed.msi/download
        # we strip /dr/ and /download if present, and append https to the front, that gives us a URL like this:
        # https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-3.6.5-signed.msi       
        $url = 'https://' + $($link).Replace('/dr/','').Replace('/download','')
    
        $version = $($url -split '-')[-2]
        $url64   = $url
        return @{ URL64=$url64; Version = $version }
    }

}

Update-Package -ChecksumFor 64 -NoCheckChocoVersion