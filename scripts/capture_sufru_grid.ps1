# Capture SÜFRÜ grid page screenshot
$chromeCandidates = @(
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
)
$chrome = $chromeCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $chrome) { Write-Error "Chrome not found"; exit 2 }

Write-Host "Building Flutter web..."
flutter build web --release
if ($LASTEXITCODE -ne 0) { Write-Error "flutter build web failed"; exit 3 }

$port = 8080
$webDir = Join-Path (Get-Location) "build\web"
$python = Get-Command python -ErrorAction SilentlyContinue
if ($python) {
    $serverProcess = Start-Process -FilePath python -ArgumentList "-m", "http.server", $port, "--directory", "$webDir" -PassThru -WindowStyle Hidden
} else { Write-Error "Python not found"; exit 5 }
Start-Sleep -Seconds 2

$outDir = Join-Path (Get-Location) "frue_sync\screens"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$logFile = Join-Path (Get-Location) "frue_sync\logs\sufru_ui_report.txt"

$url = "http://127.0.0.1:$port/?open=sufru&grid=1"
$out = Join-Path $outDir "grid_sufru.png"
Write-Host "Capturing $url -> $out"
& "$chrome" --headless=new --disable-gpu --screenshot="$out" --window-size=1400,1000 "$url"
if ($LASTEXITCODE -eq 0) { "OK: Grid -> $out" | Out-File -FilePath $logFile -Append -Encoding utf8 } else { "ERROR: Grid capture failed" | Out-File -FilePath $logFile -Append -Encoding utf8 }

if ($serverProcess -and -not $serverProcess.HasExited) { $serverProcess | Stop-Process -Force }
Write-Host "Done."
