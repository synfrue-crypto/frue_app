# Retry capture script: build web, serve build/web, capture two screenshots for brand home (sufru)
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\capture_brandhome_retry.ps1

$logDir = Join-Path -Path $PSScriptRoot -ChildPath "..\frue_sync\logs" | Resolve-Path -Relative
$logDir = (Resolve-Path (Join-Path $PSScriptRoot "..\frue_sync\logs")).ProviderPath
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

function Find-Chrome {
    $candidates = @(
        "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
        "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",
        "C:\\Program Files\\Google\\Chrome Beta\\Application\\chrome.exe"
    )
    foreach ($c in $candidates) {
        if (Test-Path $c) { return $c }
    }
    return $null
}

$chrome = Find-Chrome
if (-not $chrome) {
    Write-Error "Chrome not found in standard locations. Please install Chrome or edit this script to point to a Chrome binary."
    exit 2
}

# Build if necessary
$buildDir = Join-Path $PSScriptRoot "..\build\web" | Resolve-Path -ErrorAction SilentlyContinue
if (-not $buildDir) {
    Write-Host "build/web not found — running flutter build web --release"
    flutter build web --release 2>&1 | Out-File -FilePath (Join-Path $logDir 'PHASE2_startpage_buildlog.txt') -Encoding utf8
} else {
    Write-Host "build/web exists — skipping flutter build"
}

# Start a simple HTTP server serving build/web
$webRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\build\web")).ProviderPath
$startInfo = Start-Process -FilePath python -ArgumentList '-m','http.server','8080','--directory',$webRoot -PassThru -WindowStyle Hidden
Start-Sleep -Seconds 2

# Ensure output directories exist
$outDir = Join-Path $PSScriptRoot "..\frue_sync\screenshots"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$desktopOut = Join-Path $outDir 'brandhome_sufru_desktop.png'
$mobileOut = Join-Path $outDir 'brandhome_sufru_mobile.png'

try {
    Write-Host "Using Chrome: $chrome"
    & "$chrome" --headless=new --disable-gpu --screenshot="$desktopOut" --window-size=1200,900 "http://127.0.0.1:8080/?open=sufru" 2>&1 | Out-Null
    Start-Sleep -Milliseconds 500
    & "$chrome" --headless=new --disable-gpu --screenshot="$mobileOut" --window-size=360,800 "http://127.0.0.1:8080/?open=sufru" 2>&1 | Out-Null
    Write-Host "Captured: $desktopOut and $mobileOut"
    $report = @(
        "PHASE2_startpage - $(Get-Date -Format o)",
        "desktop: $desktopOut",
        "mobile: $mobileOut"
    )
    $report | Out-File -FilePath (Join-Path $logDir 'PHASE2_startpage_changes.txt') -Encoding utf8
} catch {
    Write-Error "Capture failed: $_"
    exit 3
} finally {
    if ($startInfo -and -not $startInfo.HasExited) {
        Stop-Process -Id $startInfo.Id -Force -ErrorAction SilentlyContinue
    }
}

Write-Host 'CAPTURE_DONE' | Out-File -FilePath (Join-Path $logDir 'PHASE2_startpage_status.txt') -Encoding utf8
Write-Host 'Done.'
