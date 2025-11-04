# Capture Startpages Script
# Builds the Flutter web app, serves it, and uses Chrome headless to capture screenshots of the three brand startpages.
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

# 1) Build web
Write-Host "Building Flutter web (release)... this may take a while"
flutter build web --release
if ($LASTEXITCODE -ne 0) { Write-Error "flutter build web failed"; exit 3 }

# 2) Start a simple static server to serve build/web
$port = 8080
$webDir = Join-Path (Get-Location) "build\web"
if (-not (Test-Path $webDir)) { Write-Error "build/web not found"; exit 4 }

Write-Host "Starting simple server to serve $webDir on port $port"
# Try Python 3 http.server
$python = Get-Command python -ErrorAction SilentlyContinue
if ($python) {
    $serverProcess = Start-Process -FilePath python -ArgumentList "-m", "http.server", $port, "--directory", "$webDir" -PassThru -WindowStyle Hidden
} else {
    Write-Error "Python not found. Please install Python 3 or serve build/web with another static server and re-run the screenshot commands manually."
    exit 5
}

Start-Sleep -Seconds 2

# Ensure output directory exists
$screensDir = Join-Path (Get-Location) "docs\screenshots_startseiten"
New-Item -ItemType Directory -Force -Path $screensDir | Out-Null

# 3) Capture screenshots via headless Chrome using the query param `?open=` to open brand pages directly
$brands = @('sufru','grufru','blufru')
foreach ($b in $brands) {
    $url = "http://127.0.0.1:$port/?open=$b"
    $out = Join-Path $screensDir "$b.png"
    Write-Host "Capturing $url -> $out"
    & "$chrome" --headless=new --disable-gpu --screenshot="$out" --window-size=1200,900 "$url"
    if ($LASTEXITCODE -ne 0) { Write-Warning "Chrome returned non-zero exit code for $b" }
    Start-Sleep -Seconds 1
}

# 4) Stop server
if ($serverProcess -and -not $serverProcess.HasExited) {
    Write-Host "Stopping server (pid $($serverProcess.Id))"
    $serverProcess | Stop-Process -Force
}

Write-Host "Screenshots saved to: $screensDir"
