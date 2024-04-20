$url = $null
$type = $null

foreach ($arg in $args) {
    if ($arg.StartsWith("-u")) {
        $url = $args[$args.IndexOf($arg) + 1]
    } elseif ($arg.StartsWith("--json")) {
        $type = "json"
    } elseif ($arg.StartsWith("--txt")) {
        $type = "txt"
    }
}

if (-not $url) {
    Write-Host "   ___|     ___|    |            _ \     ___|   _ _|    \  |  __ __|      __ __|                   | "
	Write-Host " \___ \   \___ \    |           |   |  \___ \     |      \ |     |           |      _ \     _ \    | "
	Write-Host "       |        |   |           |   |        |    |    |\  |     |           |     (   |   (   |   | "
	Write-Host "       |        |   |           |   |        |    |    |\  |     |           |     (   |   (   |   | "
	Write-Host " _____/   _____/   _____|      \___/   _____/   ___|  _| \_|    _|          _|    \___/   \___/   _| "
	
	Write-Host "Enter a Domain and we will fetch all related Domains: "
    $url = Read-Host
}

if (-not $type) {
    $response = Read-Host "Do you want to save the output to a file? (Y/n) Default(Y)"
    if ($response -eq "Y" -or $response -eq "" -or $response -eq "y") {
        $response = Read-Host "Do you want to save as (json/txt)? Default(json)"
        if ($response -eq "json" -or $response -eq "") {
            $type = "json"
        } elseif ($response -eq "txt") {
            $type = "txt"
        } else {
            Write-Host "Invaild Argument"
            $type = $null
        }
    } elseif ($response -eq "N" -or $response -eq "n") {
		Write-Host "Output will be saved !"
		$type = $null
	} else {
		Write-Host "Invalid Argument!"
		$breaker = "Done"
	}
}

if ($url -and -not $breaker) {
    Write-Host @"
 ____     __    ___  ____  _      ____    ___  _____
/    |   /  ]  /  _]|    || |    |    |  /  _]/ ___/
|  o  |  /  /  /  [_  |  | | |     |  |  /  [_(   \_ 
|     | /  /  |    _] |  | | |___  |  | |    _]\__  |
|  _  |/   \_ |   [_  |  | |     | |  | |   [_ /  \ |
|  |  |\     ||     | |  | |     | |  | |     |\    |
|__|__| \____||_____||____||_____||____||_____| \___|
"@

    Write-Host "Checking $url at crt.sh"

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:101.0) Gecko/20100101 Firefox/101.0")

    $response = Invoke-RestMethod "https://crt.sh/?q=$url&output=json" -Method 'GET' -Headers $headers
	$response | ConvertTo-Json
	
    if ($type) {
        $response | Add-Content -Path .\ssl-tool-$url.$type
        Write-Host "Output saved to ssl-tool-$url.$type"
    }

    Write-Host "Press any key to continue..."
    pause
}
