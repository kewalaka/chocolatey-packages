import-module au

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"     = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_GetLatest {

    # getting the latest version via bintray
    $rssfeed = Invoke-WebRequest 'https://www.citrix.com/content/citrix/en_us/downloads/xenserver.rss'
    $base_uri = (([xml]$rssfeed.content).rss.channel.item | Where-Object {$_.title -like '*Standard Edition*'} | Select-Object -first 1).link
    $downloadpage = Invoke-WebRequest $base_uri

    if ($downloadpage.StatusCode -eq 200)
    {
        $url = ($downloadpage.AllElements | Where-Object rel -like '*XenCenterSetup.exe').rel
        $version = ($url.split('/') | Select-Object -last 1).split('-')[1]

        @{ 
            URL32   = $url;
            Version = $version;
        }
    }

}

Update-Package