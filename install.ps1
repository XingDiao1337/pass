# ==============================================================================
# Script: Yuzaki Tool Box One-Click Automated Deployment
# Command: irm https://gitcode.com/api/v5/repos/XingDiao1337/tool/raw/install.ps1 | iex
# ==============================================================================

$ErrorActionPreference = 'Continue'
$ProgressPreference = 'SilentlyContinue'

Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
Add-Type -AssemblyName System.IO.Compression -ErrorAction SilentlyContinue

# UTF-8 Decoder for pure ASCII script representation
function S([string]$b) {
    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b))
}

# --- Phase 0: Administrator Check & Safe Elevation ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host (S 'WyFdIOajgOa1i+WIsOW9k+WJjemdnueuoeeQhuWRmOadg+mZkO+8jOato+WcqOWwneivleWUpOmGkueuoeeQhuWRmOaPkOadgy4uLg==') -ForegroundColor Green
    $scriptUrl = 'https://gitcode.com/api/v5/repos/XingDiao1337/tool/raw/install.ps1'
    $elevated = $false
    try {
        if ($PSCommandPath -and (Test-Path $PSCommandPath)) {
            $proc = Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"") -Verb RunAs -PassThru -ErrorAction Stop
            if ($proc) { $elevated = $true }
        } else {
            $cmd = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; irm '$scriptUrl' | iex"
            $proc = Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -Command `"$cmd`"") -Verb RunAs -PassThru -ErrorAction Stop
            if ($proc) { $elevated = $true }
        }
    } catch {
        Write-Host (S 'WyFdIOiHquWKqOaPkOadg+iiq+i3s+i/h+aIluacquaUr+aMge+8jOato+WcqOS7peW9k+WJjeeUqOaIt+adg+mZkOe7p+e7reaJp+ihjC4uLg==') -ForegroundColor Green
    }
    if ($elevated) {
        Exit
    }
}

try {
    # --- Phase 1: Environment & Network Protocols ---
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls

    # --- Line 1:
    $UrlsCDN = @{
        'net8'     = 'https://cdn.yuzakitsukasa.top/net8.exe'
        'Drive'    = 'https://cdn.yuzakitsukasa.top/Drive.zip'
        'publish'  = 'https://cdn.yuzakitsukasa.top/publish.zip'
        'Resource' = 'https://cdn.yuzakitsukasa.top/Resource.zip'
    }

    # --- Line 2: GitCode
    $UrlsGitCode = @{
        'net8'     = 'https://raw.gitcode.com/XingDiao1337/tool/blobs/96c6643e54a00d2c9f0cf6d707ac60a57a3b5456/net8.exe'
        'Drive'    = 'https://raw.gitcode.com/XingDiao1337/tool/blobs/6b1d9df863b8e97d376fa8dcf4659c80ac38c3fd/Drive.zip'
        'publish'  = 'https://raw.gitcode.com/XingDiao1337/tool/blobs/b45f9afff3189e9ee10aab3f6787188a9952a589/publish.zip'
        'Resource' = 'https://raw.gitcode.com/XingDiao1337/tool/blobs/7ede692c8d98de43ebaac62d524d8429b280e111/Resource.zip'
    }

    # --- Line 3: GitHub  ( ghfast )
    $UrlsGitHub = @{
        'net8'     = 'https://ghfast.top/https://github.com/XingDiao1337/pass/raw/main/net8.exe'
        'Drive'    = 'https://ghfast.top/https://github.com/XingDiao1337/pass/raw/main/Drive.zip'
        'publish'  = 'https://ghfast.top/https://github.com/XingDiao1337/pass/raw/main/publish.zip'
        'Resource' = 'https://ghfast.top/https://github.com/XingDiao1337/pass/raw/main/Resource.zip'
    }

    $ExpectedSizes = @{
        'net8'     = [long]58715896
        'Drive'    = [long]20649939
        'publish'  = [long]28595956
        'Resource' = [long]345247355
    }

    $global:ActiveLine = 'CDN'
    $global:LinesPriority = @('CDN', 'GitHub', 'GitCode')

    $PassUrls = @(
        'https://gitcode.com/api/v5/repos/XingDiao1337/tool/raw/README.md',
        'https://raw.gitcode.com/XingDiao1337/tool/raw/master/README.md',
        'https://ghfast.top/https://raw.githubusercontent.com/XingDiao1337/pass/refs/heads/main/README.md',
        'https://raw.githubusercontent.com/XingDiao1337/pass/refs/heads/main/README.md'
    )

    $RootDir     = 'C:\Yuzaki Tool Box'
    $EnvDir      = Join-Path $RootDir 'Environment'
    $DriveDir    = Join-Path $RootDir 'Drive'
    $ToolDir     = Join-Path $RootDir 'YuzakiTool'
    $ResourceDir = Join-Path $RootDir 'Resource'

    # --- ASCII Art & Author Credit ---
    $artBanner = @'
__   __                _     _   _____           _   ____            
\ \ / /_   _ ______ _ | | _ (_) |_   _|__   ___ | | | __ )  _____  __
 \ V /| | | |_  / _` || |/ / | |   | |/ _ \ / _ \| | |  _ \ / _ \ \/ /
  | | | |_| |/ / (_| ||   <  | |   | | (_) | (_) | | | |_) | (_) >  < 
  |_|  \__,_/___|__,_||_|\_\ |_|   |_|\___/ \___/|_| |____/ \___/_/\_\
'@

    Write-Host $artBanner -ForegroundColor Magenta
    Write-Host '========================================================================' -ForegroundColor Magenta
    Write-Host (S 'ICAgICAgICAgIOWIt+acuuiupOWHhiDlkrjpsbwgTTFDSzNZICB8ICDlt6XlhbfnrrHkvZzogIXvvJpC56uZ77ya5bCP5Y+45aSn546L5Za1ICAgICAgICAgIA==') -ForegroundColor Cyan
    Write-Host '========================================================================' -ForegroundColor Magenta

    # --- Phase 2: Unified Node Latency Ping & Remote Auth ---
    Write-Host (S 'WypdIOato+WcqOWFqOmdouajgOa1i+WFqOe9kee6v+i3r+S4juiKgueCueW7tui/ny4uLg==') -ForegroundColor Green

    # --- 1.  ping
    $checkNodes = @(
        [PSCustomObject]@{ Name = (S '6aaZ5riv55u06L+e5LiT57q/'); Host = 'cdn.yuzakitsukasa.top' },
        [PSCustomObject]@{ Name = (S 'R2l0Q29kZSDplZzlg48='); Host = 'raw.gitcode.com' },
        [PSCustomObject]@{ Name = (S 'R2l0SHViIOWbveWGheWKoOmAnw=='); Host = 'ghfast.top' }
    )
    $pingMainObj = New-Object System.Net.NetworkInformation.Ping
    foreach ($nd in $checkNodes) {
        $pVal = -1
        try {
            $r = $pingMainObj.Send($nd.Host, 1000)
            if ($r.Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
                $pVal = [int]$r.RoundtripTime
            }
        } catch {}
        $pMsg = if ($pVal -ge 0) { "$pVal ms" } else { (S '5peg5rOV55u06L+e') }
        Write-Host ('      [' + $nd.Name + '] ' + $nd.Host + ' -> ' + $pMsg) -ForegroundColor Green
    }
    $pingMainObj.Dispose()

    # --- 2.
    Write-Host (S 'WypdIOato+WcqOi/nuaOpeWuieWFqOacjeWKoeWZqOagoemqjOiuv+mXruadg+mZkC4uLg==') -ForegroundColor Green
    $pingPassObj = New-Object System.Net.NetworkInformation.Ping
    $passCandidates = @()
    foreach ($u in $PassUrls) {
        $uHost = ([System.Uri]$u).Host
        $rtt = 9999
        try {
            $r = $pingPassObj.Send($uHost, 1000)
            if ($r.Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
                $rtt = [int]$r.RoundtripTime
            }
        } catch {}
        $passCandidates += [PSCustomObject]@{ Url = $u; Host = $uHost; Latency = $rtt }
    }
    $pingPassObj.Dispose()

    $sortedPass = $passCandidates | Sort-Object Latency
    $bestPass = $sortedPass[0]
    if ($bestPass.Latency -lt 9999) {
        Write-Host ((S 'ICAgICAgWytdIOWvhueggeacjeWKoeW3suiHquWKqOS8mOmAiTog') + $bestPass.Host + (S 'IChQaW5nIOW7tui/nzog') + $bestPass.Latency + 'ms)') -ForegroundColor Green
    }

    $correctPass = $null
    foreach ($item in $sortedPass) {
        try {
            $wcPass = New-Object System.Net.WebClient
            $wcPass.Headers.Add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36')
            $rawPass = $wcPass.DownloadString($item.Url)
            $wcPass.Dispose()
            if ($rawPass -and ($rawPass.Trim().Length -gt 0)) {
                $correctPass = $rawPass.Trim()
                break
            }
        } catch {}
    }

    if (-not $correctPass) {
        Write-Host (S 'Wy1dIOaXoOazlei/nuaOpeWIsOi/nOeoi+WvhueggeagoemqjOacjeWKoeWZqO+8jOivt+ajgOafpeaCqOeahOe9kee7nOi/nuaOpe+8gQ==') -ForegroundColor Red
        Write-Host (S '5oyJ5Zue6L2m6ZSu6YCA5Ye6Li4u') -ForegroundColor Red
        [void][Console]::ReadLine()
        Exit
    }

    # --- 3.
    $authPassed = $false
    for ($attempt = 1; $attempt -le 3; $attempt++) {
        Write-Host (S 'Wz9dIOivt+i+k+WFpeS9v+eUqOWvhueggTog') -ForegroundColor Green -NoNewline
        $secPass = Read-Host -AsSecureString
        $inputPass = if ($secPass) { [System.Net.NetworkCredential]::new('', $secPass).Password } else { '' }
        
        if ($inputPass -and ($inputPass.Trim() -eq $correctPass)) {
            Write-Host (S 'WytdIOWvhueggemqjOivgemAmui/h++8jOaOiOadg+aIkOWKn++8gQ==') -ForegroundColor Green
            $authPassed = $true
            break
        } else {
            $remaining = 3 - $attempt
            if ($remaining -gt 0) {
                Write-Host ((S 'Wy1dIOWvhueggemUmeivr++8geWJqeS9meWwneivleasoeaVsDog') + $remaining) -ForegroundColor Red
            } else {
                Write-Host (S 'Wy1dIOWvhueggemUmeivr+asoeaVsOi/h+Wkmu+8jOiuv+mXruW3suiiq+aLkue7ne+8gQ==') -ForegroundColor Red
            }
        }
    }

    if (-not $authPassed) {
        Start-Sleep -Seconds 2
        Exit
    }

    # --- Phase 3: Directory Structure Initialization ---
    Write-Host (S 'WzEvNl0g5q2j5Zyo5Yid5aeL5YyW5pys5Zyw55uu5b2V57uT5p6ELi4u') -ForegroundColor Green
    $Directories = @($RootDir, $EnvDir, $DriveDir, $ToolDir, $ResourceDir)
    foreach ($dir in $Directories) {
        if (-not (Test-Path -Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
    Write-Host ((S 'ICAgICAg55uu5b2V5p625p6E5Yib5bu65a6M5oiQOiA=') + $RootDir) -ForegroundColor Green

    # --- Fast Multi-Threaded Engine Registration with Cancellation Support ---
    if (-not ('FastDownloader' -as [type])) {
        $csharpCode = @'
using System;
using System.IO;
using System.Net;
using System.Threading;
using System.Threading.Tasks;

public class FastDownloader {
    public static long DownloadedBytes = 0;
    public static long TotalBytes = 0;
    public static bool IsCompleted = false;
    public static bool IsCancelled = false;
    public static string ErrorMessage = null;
    private static CancellationTokenSource _cts = null;

    public static void CancelDownload() {
        IsCancelled = true;
        if (_cts != null) {
            try { _cts.Cancel(); } catch {}
        }
    }

    public static void StartDownload(string url, string destPath, int threads, long expectedBytes = 0) {
        DownloadedBytes = 0;
        TotalBytes = 0;
        IsCompleted = false;
        IsCancelled = false;
        ErrorMessage = null;

        if (_cts != null) {
            try { _cts.Cancel(); _cts.Dispose(); } catch {}
        }
        _cts = new CancellationTokenSource();
        CancellationToken token = _cts.Token;

        ServicePointManager.DefaultConnectionLimit = 64;
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

        try {
            HttpWebRequest headReq = (HttpWebRequest)WebRequest.Create(url);
            headReq.Method = "HEAD";
            headReq.UserAgent = "Mozilla/5.0";
            headReq.Timeout = 10000;
            using (HttpWebResponse resp = (HttpWebResponse)headReq.GetResponse()) {
                TotalBytes = resp.ContentLength;
            }
        } catch {}

        if (TotalBytes <= 0 && expectedBytes > 0) {
            TotalBytes = expectedBytes;
        }

        bool supportsRange = false;
        if (TotalBytes > 2 * 1024 * 1024) {
            try {
                HttpWebRequest rReq = (HttpWebRequest)WebRequest.Create(url);
                rReq.UserAgent = "Mozilla/5.0";
                rReq.AddRange(0, 1023);
                rReq.Timeout = 8000;
                using (HttpWebResponse rResp = (HttpWebResponse)rReq.GetResponse()) {
                    if ((int)rResp.StatusCode == 206) supportsRange = true;
                }
            } catch {}
        }

        if (!supportsRange) {
            Task.Run(() => {
                try {
                    HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
                    req.UserAgent = "Mozilla/5.0";
                    req.Timeout = 180000;
                    using (HttpWebResponse r = (HttpWebResponse)req.GetResponse())
                    using (Stream s = r.GetResponseStream())
                    using (FileStream fs = File.Create(destPath)) {
                        byte[] buf = new byte[65536];
                        int read;
                        while (!token.IsCancellationRequested && (read = s.Read(buf, 0, buf.Length)) > 0) {
                            fs.Write(buf, 0, read);
                            Interlocked.Add(ref DownloadedBytes, read);
                        }
                    }
                    if (token.IsCancellationRequested) {
                        try { File.Delete(destPath); } catch {}
                    }
                } catch (Exception ex) {
                    if (!token.IsCancellationRequested) ErrorMessage = ex.Message;
                } finally {
                    IsCompleted = true;
                }
            }, token);
            return;
        }

        long chunkSize = TotalBytes / threads;
        Task[] tasks = new Task[threads];
        string[] partFiles = new string[threads];

        for (int i = 0; i < threads; i++) {
            int idx = i;
            long start = idx * chunkSize;
            long end = (idx == threads - 1) ? TotalBytes - 1 : (start + chunkSize - 1);
            string partPath = destPath + ".part" + idx;
            partFiles[idx] = partPath;

            tasks[idx] = Task.Run(() => {
                try {
                    HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
                    req.UserAgent = "Mozilla/5.0";
                    req.AddRange(start, end);
                    req.Timeout = 60000;
                    using (HttpWebResponse r = (HttpWebResponse)req.GetResponse())
                    using (Stream s = r.GetResponseStream())
                    using (FileStream fs = File.Create(partPath)) {
                        byte[] buf = new byte[65536];
                        int read;
                        while (!token.IsCancellationRequested && (read = s.Read(buf, 0, buf.Length)) > 0) {
                            fs.Write(buf, 0, read);
                            Interlocked.Add(ref DownloadedBytes, read);
                        }
                    }
                } catch (Exception ex) {
                    if (!token.IsCancellationRequested) ErrorMessage = ex.Message;
                }
            }, token);
        }

        Task.Run(() => {
            try {
                Task.WaitAll(tasks);
                if (token.IsCancellationRequested) {
                    for (int i = 0; i < threads; i++) {
                        try { File.Delete(partFiles[i]); } catch {}
                    }
                    try { File.Delete(destPath); } catch {}
                    return;
                }
                using (FileStream outFs = File.Create(destPath)) {
                    for (int i = 0; i < threads; i++) {
                        using (FileStream inFs = File.OpenRead(partFiles[i])) {
                            inFs.CopyTo(outFs);
                        }
                        try { File.Delete(partFiles[i]); } catch {}
                    }
                }
            } catch (Exception ex) {
                if (!token.IsCancellationRequested) ErrorMessage = ex.Message;
            } finally {
                IsCompleted = true;
            }
        });
    }
}
'@
        Add-Type -TypeDefinition $csharpCode
    }

    # --- Phase 5 Helper: Re-ping Download Lines & Select Lowest Latency ---
    function Select-BestDownloadLine {
        Write-Host (S 'WypdIOato+WcqOWunuaXtuivhOS8sOS4i+i9vee6v+i3r+i0qOmHj+S4juW7tui/nyAo6aaZ5riv5LiT57q/IC8gR2l0Q29kZSAvIEdpdEh1YuWKoOmAnykuLi4=') -ForegroundColor Green
        $linePings = @()
        $pingObj = New-Object System.Net.NetworkInformation.Ping

        # --- Node 1:
        $cdnPing = 9999
        try {
            $r = $pingObj.Send('cdn.yuzakitsukasa.top', 1200)
            if ($r.Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
                $cdnPing = [int]$r.RoundtripTime
            }
        } catch {}
        $linePings += [PSCustomObject]@{ Id = 'CDN'; Name = (S '6aaZ5riv55u06L+e5LiT57q/'); Host = 'cdn.yuzakitsukasa.top'; Ping = $cdnPing }

        # --- Node 2: GitHub
        $ghPing = 9999
        try {
            $r = $pingObj.Send('ghfast.top', 1200)
            if ($r.Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
                $ghPing = [int]$r.RoundtripTime
            }
        } catch {}
        $linePings += [PSCustomObject]@{ Id = 'GitHub'; Name = (S 'R2l0SHViIOWKoOmAn+S4k+e6vw=='); Host = 'ghfast.top'; Ping = $ghPing }

        # --- Node 3: GitCode
        $gitPing = 9999
        try {
            $r = $pingObj.Send('raw.gitcode.com', 1200)
            if ($r.Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
                $gitPing = [int]$r.RoundtripTime
            }
        } catch {}
        $linePings += [PSCustomObject]@{ Id = 'GitCode'; Name = (S 'R2l0Q29kZSDplZzlg48='); Host = 'raw.gitcode.com'; Ping = $gitPing }

        $pingObj.Dispose()

        # --- ping
        foreach ($lp in $linePings) {
            $pDisplay = if ($lp.Ping -lt 9999) { "$($lp.Ping) ms" } else { (S '5peg5rOV55u06L+e') }
            Write-Host ('      [' + $lp.Name + '] ' + $lp.Host + ' -> ' + $pDisplay) -ForegroundColor Green
        }

        # --- 
        $sortedLines = $linePings | Sort-Object Ping
        $bestLine = $sortedLines[0]
        if ($bestLine.Ping -ge 9999) {
            $global:ActiveLine = 'GitHub'
        } else {
            $global:ActiveLine = $bestLine.Id
        }

        # --- 
        $global:LinesPriority = @($sortedLines | ForEach-Object { $_.Id })

        $activeName = if ($global:ActiveLine -eq 'CDN') { (S '6aaZ5riv55u06L+e5LiT57q/') } elseif ($global:ActiveLine -eq 'GitHub') { (S 'R2l0SHViIOWKoOmAn+S4k+e6vw==') } else { (S 'R2l0Q29kZSDplZzlg48=') }
        Write-Host ((S 'ICAgICAgLT4g5bey6Ieq5Yqo5LyY6YCJ5pyA5L2z5LiL6L2957q/6LevOiBb') + $activeName + (S 'XQ==')) -ForegroundColor Green
    }

    # --- Phase 4: Download Engine with Live Smooth Progress Bar & Multi-Line Auto-Switch ---
    function Download-WithAutoSwitch {
        param (
            [string]$Key,
            [string]$Destination,
            [string]$DisplayName,
            [int]$Threads = 6
        )
        $expectedBytes = [long]$ExpectedSizes[$Key]
        
        # --- 
        $linesToTry = @()
        if ($global:LinesPriority) {
            $linesToTry = @($global:ActiveLine) + @($global:LinesPriority | Where-Object { $_ -ne $global:ActiveLine })
        } else {
            $linesToTry = @('CDN', 'GitHub', 'GitCode')
        }

        for ($attempt = 0; $attempt -lt $linesToTry.Count; $attempt++) {
            $curLine = $linesToTry[$attempt]
            $url = if ($curLine -eq 'GitCode') { $UrlsGitCode[$Key] } elseif ($curLine -eq 'GitHub') { $UrlsGitHub[$Key] } else { $UrlsCDN[$Key] }
            $lineName = if ($curLine -eq 'GitCode') { (S 'R2l0Q29kZSDplZzlg48=') } elseif ($curLine -eq 'GitHub') { (S 'R2l0SHViIOWKoOmAn+S4k+e6vw==') } else { (S '6aaZ5riv55u06L+e5LiT57q/') }

            Write-Host ((S 'WytdIOato+WcqOS4i+i9vTog') + $DisplayName + ' [' + $lineName + ']') -ForegroundColor Green

            $cBlock = [char]9608
            $cEmpty = [char]9617
            $cr = [char]13
            $barLen = 25
            $sw = [System.Diagnostics.Stopwatch]::StartNew()

            [FastDownloader]::StartDownload($url, $Destination, $Threads, $expectedBytes)

            $switchedDueToSpeed = $false
            while (-not [FastDownloader]::IsCompleted) {
                $down = [FastDownloader]::DownloadedBytes
                $totalBytes = [FastDownloader]::TotalBytes
                $pct = if ($totalBytes -gt 0) { [math]::Round(($down / $totalBytes) * 100, 1) } else { 0 }
                $elapsedSec = $sw.Elapsed.TotalSeconds
                $speed = if ($elapsedSec -gt 0) { [math]::Round(($down / 1MB) / $elapsedSec, 2) } else { 0 }
                $downMB = [math]::Round($down / 1MB, 1)
                $totMB = if ($totalBytes -gt 0) { [math]::Round($totalBytes / 1MB, 1) } else { [math]::Round($expectedBytes / 1MB, 1) }
                $filled = [math]::Min($barLen, [math]::Floor($pct / 100 * $barLen))
                $bar = ($cBlock.ToString() * $filled) + ($cEmpty.ToString() * ($barLen - $filled))

                try {
                    $pos = $Host.UI.RawUI.CursorPosition
                    $pos.X = 0
                    $Host.UI.RawUI.CursorPosition = $pos
                } catch {}

                $mtTag = if ($totalBytes -gt 2*1024*1024 -and ($curLine -eq 'CDN' -or $curLine -eq 'GitHub')) { (S 'ICjlpJrnur/nqIvliqDpgJ8p') } else { '' }
                $lineStr = $cr + '      [' + $bar + '] ' + $pct + '% (' + $downMB + 'MB/' + $totMB + 'MB) ' + $speed + ' MB/s' + $mtTag + '      '
                Write-Host -NoNewline $lineStr -ForegroundColor Green

                # --- 6  75%  < 0.40 MB/s
                if ($attempt -lt ($linesToTry.Count - 1)) {
                    if ($elapsedSec -ge 6.0 -and $pct -lt 75.0 -and $speed -lt 0.40) {
                        [FastDownloader]::CancelDownload()
                        $switchedDueToSpeed = $true
                        while (-not [FastDownloader]::IsCompleted) {
                            Start-Sleep -Milliseconds 50
                        }
                        break
                    }
                }

                Start-Sleep -Milliseconds 120
            }

            $sw.Stop()

            if ($switchedDueToSpeed) {
                Write-Host ''
                Write-Host (S 'ICAgICAgWyFdIOajgOa1i+WIsOW9k+WJjee6v+i3r+S4i+i9vemAn+W6pui/h+aFou+8jOato+WcqOiHquWKqOaXoOe8neWIh+aNouiHs+Wkh+eUqOmrmOmAn+e6v+i3ry4uLg==') -ForegroundColor Yellow
                $nextIdx = ($attempt + 1) % $linesToTry.Count
                $global:ActiveLine = $linesToTry[$nextIdx]
                try { if (Test-Path $Destination) { Remove-Item $Destination -Force -ErrorAction SilentlyContinue } } catch {}
                continue
            }

            if ([FastDownloader]::ErrorMessage -or -not (Test-Path $Destination) -or ((Get-Item $Destination).Length -lt 1024)) {
                $errMsg = [FastDownloader]::ErrorMessage
                Write-Host ''
                if ($attempt -lt ($linesToTry.Count - 1)) {
                    Write-Host ((S 'ICAgICAgWyFdIOW9k+WJjee6v+i3r+i/nuaOpeW8guW4uO+8jOato+WcqOiHquWKqOaVhemanOi9rOenu+iHs+Wkh+eUqOmrmOmAn+e6v+i3rzog') + $errMsg) -ForegroundColor Yellow
                    $nextIdx = ($attempt + 1) % $linesToTry.Count
                    $global:ActiveLine = $linesToTry[$nextIdx]
                    try { if (Test-Path $Destination) { Remove-Item $Destination -Force -ErrorAction SilentlyContinue } } catch {}
                    continue
                } else {
                    Write-Host ((S 'Wy1dIOS4i+i9veWksei0pTog') + $DisplayName + ' - ' + $errMsg) -ForegroundColor Red
                    throw $errMsg
                }
            }

            $finalMB = [math]::Round((Get-Item $Destination).Length / 1MB, 2)
            $fullBar = $cBlock.ToString() * $barLen
            try {
                $pos = $Host.UI.RawUI.CursorPosition
                $pos.X = 0
                $Host.UI.RawUI.CursorPosition = $pos
            } catch {}
            Write-Host ($cr + '      [' + $fullBar + '] 100% (' + $finalMB + 'MB/' + $finalMB + 'MB)' + (S 'IOWujOaIkCEgICA=') + '      ') -ForegroundColor Green
            Write-Host ('      ' + $DisplayName + (S 'IOS4i+i9veWujOaIkCAo6ICX5pe2OiA=') + [math]::Round($sw.Elapsed.TotalSeconds, 1) + (S 'cyk=')) -ForegroundColor Green
            break
        }
    }

    # --- High-Speed Zip Extraction Engine with Smooth Progress Bar ---
    function Expand-WithProgress {
        param (
            [string]$ZipPath,
            [string]$DestinationPath,
            [string]$DisplayName
        )
        Write-Host ((S 'WytdIOato+WcqOino+WOizog') + $DisplayName + '...') -ForegroundColor Green

        if (-not (Test-Path $DestinationPath)) {
            New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
        }

        $cBlock = [char]9608
        $cEmpty = [char]9617
        $cr = [char]13
        $barLen = 25
        $sw = [System.Diagnostics.Stopwatch]::StartNew()

        try {
            $archive = [System.IO.Compression.ZipFile]::OpenRead($ZipPath)
            $entries = $archive.Entries
            $totalCount = $entries.Count
            $processed = 0
            $lastUpdate = 0

            foreach ($entry in $entries) {
                $processed++
                $targetFilePath = [System.IO.Path]::Combine($DestinationPath, $entry.FullName)

                if ($entry.FullName.EndsWith('/') -or $entry.FullName.EndsWith('\')) {
                    if (-not (Test-Path $targetFilePath)) {
                        New-Item -ItemType Directory -Path $targetFilePath -Force | Out-Null
                    }
                    continue
                }

                $parentDir = [System.IO.Path]::GetDirectoryName($targetFilePath)
                if (-not (Test-Path $parentDir)) {
                    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
                }

                [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $targetFilePath, $true)

                if ($sw.ElapsedMilliseconds - $lastUpdate -gt 80) {
                    $lastUpdate = $sw.ElapsedMilliseconds
                    $pct = if ($totalCount -gt 0) { [math]::Round(($processed / $totalCount) * 100, 1) } else { 0 }
                    $filled = [math]::Min($barLen, [math]::Floor($pct / 100 * $barLen))
                    $bar = ($cBlock.ToString() * $filled) + ($cEmpty.ToString() * ($barLen - $filled))

                    try {
                        $pos = $Host.UI.RawUI.CursorPosition
                        $pos.X = 0
                        $Host.UI.RawUI.CursorPosition = $pos
                    } catch {}

                    $lineStr = $cr + '      [' + $bar + '] ' + $pct + '% (' + $processed + '/' + $totalCount + (S 'IOS4quaWh+S7tg==') + ')      '
                    Write-Host -NoNewline $lineStr -ForegroundColor Green
                }
            }
            $archive.Dispose()

            $fullBar = $cBlock.ToString() * $barLen
            try {
                $pos = $Host.UI.RawUI.CursorPosition
                $pos.X = 0
                $Host.UI.RawUI.CursorPosition = $pos
            } catch {}

            Write-Host ($cr + '      [' + $fullBar + '] 100% (' + $totalCount + '/' + $totalCount + (S 'IOS4quaWh+S7tg==') + ')' + (S 'IOino+WOi+WujOaIkCEgICA=') + '      ') -ForegroundColor Green
            Write-Host ('      ' + $DisplayName + (S 'IOino+WOi+WujOaIkCAo6ICX5pe2OiA=') + [math]::Round($sw.Elapsed.TotalSeconds, 1) + (S 'cyk=')) -ForegroundColor Green
        }
        catch {
            Expand-Archive -Path $ZipPath -DestinationPath $DestinationPath -Force
        }
        finally {
            $sw.Stop()
        }
    }

    # --- Interactive Confirm Download (y/n) ---
    function Confirm-Download([string]$DisplayName) {
        while ($true) {
            Write-Host ((S 'Wz9dIOaYr+WQpuehruWumuS4i+i9veW5tumFjee9rjog') + $DisplayName + (S 'PyBbWS9OXSAo6buY6K6kIFkpOiA=')) -ForegroundColor Green -NoNewline
            $raw = Read-Host
            $ans = if ($raw) { $raw.Trim().ToLower() } else { '' }
            if ($ans -eq 'y' -or $ans -eq 'yes' -or $ans -eq '' -or ($raw.Trim() -eq (S '5piv'))) {
                return $true
            }
            if ($ans -eq 'n' -or $ans -eq 'no' -or ($raw.Trim() -eq (S '5ZCm'))) {
                Write-Host ((S 'ICAgICAg5bey6Lez6L+HOiA=') + $DisplayName + (S 'IOeahOS4i+i9veS4jumFjee9rg==')) -ForegroundColor Green
                return $false
            }
            Write-Host (S 'Wy1dIOi+k+WFpeaXoOaViO+8jOivt+i+k+WFpSBZIOaIliBO77yB') -ForegroundColor Red
        }
    }

    # --- Phase 5: Download & Deploy All Resources (With Pre-download Ping) ---
    Write-Host (S 'WzIvNl0g5q2j5Zyo5LuO6auY6YCf57q/6Lev6I635Y+W6LWE5rqQ5YyFLi4u') -ForegroundColor Green
    Select-BestDownloadLine

    # 1. net8.exe
    $net8Path = Join-Path $EnvDir 'net8.exe'
    if (Test-Path $net8Path) {
        Write-Host (S 'ICAgICAg5qOA5rWL5YiwIEVudmlyb25tZW50XG5ldDguZXhlIOW3suWtmOWcqO+8jOi3s+i/h+mHjeWkjeS4i+i9vQ==') -ForegroundColor Green
    } else {
        $net8Title = S 'TWljcm9zb2Z0IC5ORVQgOCDmoYzpnaLov5DooYzlupM='
        if (Confirm-Download -DisplayName $net8Title) {
            Download-WithAutoSwitch -Key 'net8' -Destination $net8Path -DisplayName $net8Title
        }
    }

    # 2. Drive.zip
    $driveTitle = S '6amx5Yqo5ouT5bGV5YyFIChEcml2ZS56aXAp'
    if (Confirm-Download -DisplayName $driveTitle) {
        $driveZip = Join-Path $RootDir 'Drive_temp.zip'
        Download-WithAutoSwitch -Key 'Drive' -Destination $driveZip -DisplayName $driveTitle
        Expand-WithProgress -ZipPath $driveZip -DestinationPath $DriveDir -DisplayName $driveTitle
        Remove-Item -Path $driveZip -Force -ErrorAction SilentlyContinue
    }

    # 3. publish.zip
    $toolTitle = S '5bel5YW3566x5qC45b+D56iL5bqPIChwdWJsaXNoLnppcCk='
    if (Confirm-Download -DisplayName $toolTitle) {
        $toolZip = Join-Path $RootDir 'publish_temp.zip'
        Download-WithAutoSwitch -Key 'publish' -Destination $toolZip -DisplayName $toolTitle
        Expand-WithProgress -ZipPath $toolZip -DestinationPath $ToolDir -DisplayName $toolTitle
        Remove-Item -Path $toolZip -Force -ErrorAction SilentlyContinue
    }

    # 4. Resource.zip
    $resTitle = S '546p5py65ouT5bGV6LWE5rqQ5LiO5qih5Z2X5YyFIChSZXNvdXJjZS56aXAp'
    if (Confirm-Download -DisplayName $resTitle) {
        $resZip = Join-Path $RootDir 'Resource_temp.zip'
        Download-WithAutoSwitch -Key 'Resource' -Destination $resZip -DisplayName $resTitle
        Expand-WithProgress -ZipPath $resZip -DestinationPath $ResourceDir -DisplayName $resTitle
        Remove-Item -Path $resZip -Force -ErrorAction SilentlyContinue
    }

    # --- Phase 6: Silent .NET 8 Desktop Runtime Installation ---
    Write-Host (S 'WzMvNl0g5q2j5Zyo6YWN572uIC5ORVQgOCDmoYzpnaLov5DooYzlupMuLi4=') -ForegroundColor Green
    $isNet8Installed = $false
    try {
        $regNet8 = Get-ChildItem 'HKLM:\SOFTWARE\dotnet\Setup\InstalledVersions\x64\sharedfx\Microsoft.WindowsDesktop.App' -ErrorAction SilentlyContinue
        if ($regNet8 -and ($regNet8.PSChildName -match '^8\.')) {
            $isNet8Installed = $true
        }
    } catch {}

    if ($isNet8Installed) {
        Write-Host (S 'ICAgICAg5qOA5rWL5Yiw57O757uf5bey5a6J6KOFIC5ORVQgOCDmoYzpnaLov5DooYzlupPvvIzml6DpnIDph43lpI3lronoo4XvvIE=') -ForegroundColor Green
    } else {
        if (Test-Path $net8Path) {
            Write-Host (S 'ICAgICAg5q2j5Zyo5ZCO5Y+w6Z2Z6buY5a6J6KOFICjor7fnqI3lgJkpLi4u') -ForegroundColor Green
            $pNet8 = Start-Process -FilePath $net8Path -ArgumentList '/install /quiet /norestart' -Wait -PassThru -ErrorAction SilentlyContinue
            Write-Host (S 'ICAgICAgLk5FVCA4IOi/kOihjOW6k+WuieijheWujOaIkA==') -ForegroundColor Green
        } else {
            Write-Host (S 'ICAgICAg5pyq5LiL6L29IG5ldDguZXhl77yM6Lez6L+H5a6J6KOF') -ForegroundColor Green
        }
    }

    # --- Phase 7: Drivers & USB 3.0 Compatibility Patch ---
    Write-Host (S 'WzQvNl0g5q2j5Zyo6YWN572u6K6+5aSH5bqV5bGC6amx5YqoLi4u') -ForegroundColor Green

    $hasDriveFiles = (Test-Path $DriveDir) -and ((Get-ChildItem $DriveDir -ErrorAction SilentlyContinue).Count -gt 0)
    if ($hasDriveFiles) {
        # 1. PnPUtil inf driver registration
        try {
            $infFiles = Get-ChildItem -Path $DriveDir -Filter '*.inf' -Recurse -ErrorAction SilentlyContinue
            if ($infFiles -and $infFiles.Count -gt 0) {
                Write-Host ((S 'ICAgICAg5q2j5Zyo5bqV5bGC5rOo5YaMIA==') + $infFiles.Count + (S 'IOS4qumpseWKqOmFjee9ruaWh+S7ti4uLg==')) -ForegroundColor Green
                Start-Process -FilePath 'pnputil.exe' -ArgumentList ('/add-driver "' + $DriveDir + '\*.inf" /subdirs /install') -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
            }
        } catch {}

        # 2. OnePlus/OPPO ADB driver
        $adbExe = Join-Path $DriveDir 'adb.exe'
        if (Test-Path $adbExe) {
            Write-Host (S 'ICAgICAg5q2j5Zyo6Z2Z6buY5a6J6KOF5LiA5YqgL09QUE8g5a6Y5pa5IEFEQiDpqbHliqguLi4=') -ForegroundColor Green
            Start-Process -FilePath $adbExe -ArgumentList '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' -Wait -ErrorAction SilentlyContinue
        }

        # 3. Qualcomm 9008 Driver
        $qcExe = Join-Path $DriveDir 'Qualcomm_HS-USB_Driver.exe'
        if (Test-Path $qcExe) {
            Write-Host (S 'ICAgICAg5q2j5Zyo6Z2Z6buY6YWN572u6auY6YCaIEhTLVVTQiA5MDA4IOmpseWKqC4uLg==') -ForegroundColor Green
            Start-Process -FilePath $qcExe -ArgumentList '/s' -Wait -ErrorAction SilentlyContinue
        }
    } else {
        Write-Host (S 'ICAgICAg5pyq5qOA5rWL5Yiw5bey6Kej5Y6L6amx5Yqo77yM6Lez6L+H6amx5Yqo6YWN572u') -ForegroundColor Green
    }

    # 4. USB 3.0 Fastboot Registry Patch
    Write-Host (S 'ICAgICAg5q2j5Zyo5bqU55SoIEZhc3Rib290IFVTQiAzLjAg5rOo5YaM6KGo6Ziy5Y2h6aG/6KGl5LiBLi4u') -ForegroundColor Green
    try {
        $regKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100'
        if (-not (Test-Path -Path $regKey)) {
            New-Item -Path $regKey -Force -ErrorAction Stop | Out-Null
        }
        Set-ItemProperty -Path $regKey -Name 'osvc' -Value ([byte[]]@(0x00, 0x00)) -Type Binary -ErrorAction Stop
        Set-ItemProperty -Path $regKey -Name 'SkipContainerIdQuery' -Value ([byte[]]@(0x01, 0x00, 0x00, 0x00)) -Type Binary -ErrorAction Stop
        Set-ItemProperty -Path $regKey -Name 'SkipBOSDescriptorQuery' -Value ([byte[]]@(0x01, 0x00, 0x00, 0x00)) -Type Binary -ErrorAction Stop
        Write-Host (S 'ICAgICAg5bqV5bGC6amx5Yqo5LiO5YW85a656KGl5LiB6YOo572y5a6M5oiQ') -ForegroundColor Green
    } catch {
        Write-Host (S 'ICAgICAgWyFdIOaPkOekujog5b2T5YmN5p2D6ZmQ5LiN6Laz5Lul5L+u5pS557O757uf5rOo5YaM6KGo77yM6Lez6L+HIFVTQiAzLjAg6KGl5LiB77yI5LiN5b2x5ZON6L2v5Lu26L+Q6KGM77yJ') -ForegroundColor Green
    }

    # --- Phase 8: Launch Main App ---
    Write-Host (S 'WzUvNl0g5q2j5Zyo5ouJ6LW35Li756iL5bqPLi4u') -ForegroundColor Green
    $mainApp = Join-Path $ToolDir 'YuzakiToolBox.exe'
    if (Test-Path $mainApp) {
        Start-Process -FilePath $mainApp -WorkingDirectory $ToolDir
        Write-Host (S 'ICAgICAgWXV6YWtpVG9vbEJveC5leGUg5bey5oiQ5Yqf5ZCv5Yqo77yB') -ForegroundColor Green
    } else {
        Write-Host ((S 'Wy1dIOacquWcqCA=') + $ToolDir + (S 'IOaJvuWIsCBZdXpha2lUb29sQm94LmV4Ze+8jOivt+ajgOafpeWOi+e8qeWMhe+8gQ==')) -ForegroundColor Red
    }

    # --- Phase 9: Self-Destruct & Finish ---
    Write-Host (S 'WzYvNl0g6YOo572y5YWo6YOo5a6M5oiQ77yM5q2j5Zyo5omn6KGM6Ieq5q+B5riF55CGLi4u') -ForegroundColor Green
    if ($PSCommandPath -and (Test-Path $PSCommandPath)) {
        $delCmd = 'ping 127.0.0.1 -n 2 >nul & del /f /q "' + $PSCommandPath + '"'
        Start-Process cmd.exe -ArgumentList ('/c ' + $delCmd) -WindowStyle Hidden
    }
    Write-Host '========================================================================' -ForegroundColor Magenta
    Write-Host (S 'ICAgICAgICAgICAgICAgIOelneaCqOS9v+eUqOaEieW/q++8geW9k+WJjeeql+WPo+WwhuWcqCAzIOenkuWQjuiHquWKqOWFs+mXrS4uLiAgICAgICAgICAgIA==') -ForegroundColor Green
    Write-Host '========================================================================' -ForegroundColor Magenta
    Start-Sleep -Seconds 3

} catch {
    Write-Host ((S 'Wy1dIOi/kOihjOi/h+eoi+S4reWPkeeUn+acqumihOacn+eahOW8guW4uDog') + $_.Exception.Message) -ForegroundColor Red
    Write-Host (S '6K+35oyJ5Zue6L2m6ZSu5p+l55yL5pel5b+X5bm26YCA5Ye6Li4u') -ForegroundColor Red
    [void][Console]::ReadLine()
}
