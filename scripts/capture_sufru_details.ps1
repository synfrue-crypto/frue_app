# Capture SÜFRÜ detail pages
# Builds the Flutter web app, serves it, and captures screenshots of specified SÜFRÜ product detail pages.
# Usage: run from repository root in PowerShell

$chromeCandidates = @(
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
)

$chrome = $chromeCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $chrome) {
    Write-Error "Chrome not found in standard locations. Please install Chrome or adjust the script to point to your chrome.exe."
    exit 2
}

Write-Host "Building Flutter web (release)..."
flutter build web --release
if ($LASTEXITCODE -ne 0) { Write-Error "flutter build web failed"; exit 3 }

$port = 8080
$webDir = Join-Path (Get-Location) "build\web"
if (-not (Test-Path $webDir)) { Write-Error "build/web not found"; exit 4 }

Write-Host "Starting simple server to serve $webDir on port $port"
$python = Get-Command python -ErrorAction SilentlyContinue
if ($python) {
    $serverProcess = Start-Process -FilePath python -ArgumentList "-m", "http.server", $port, "--directory", "$webDir" -PassThru -WindowStyle Hidden
} else {
    Write-Error "Python not found. Please install Python 3 or serve build/web with another static server and re-run the screenshot commands manually."
    exit 5
}
Start-Sleep -Seconds 2

# Ensure output directory exists
$outDir = Join-Path (Get-Location) "frue_sync\screens"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

# Ensure log directory exists
$logDir = Join-Path (Get-Location) "frue_sync\logs"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$logFile = Join-Path $logDir "sufru_ui_report.txt"
"SÜFRÜ Detail Screenshot Report - $(Get-Date)" | Out-File -FilePath $logFile -Encoding utf8

# Products to capture
$products = @('SFRU-001','SFRU-012','SFRU-023')
foreach ($p in $products) {
    $url = "http://127.0.0.1:$port/?open=sufru&detail=$p"
    $out = Join-Path $outDir "detail_$p.png"
    Write-Host "Capturing $url -> $out"
    & "$chrome" --headless=new --disable-gpu --screenshot="$out" --window-size=1200,1000 "$url"
    if ($LASTEXITCODE -eq 0) {
        "OK: $p -> $out" | Out-File -FilePath $logFile -Append -Encoding utf8
    } else {
        "ERROR: Failed capture for $p (exit $LASTEXITCODE)" | Out-File -FilePath $logFile -Append -Encoding utf8
    }
    Start-Sleep -Seconds 1
}

# Stop server
if ($serverProcess -and -not $serverProcess.HasExited) {
    $serverProcess | Stop-Process -Force
}

Write-Host "Screenshots saved to: $outDir"
Write-Host "Log written to: $logFile"
