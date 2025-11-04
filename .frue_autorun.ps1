# .\frue_autorun.ps1
# Automatische Ausführung ohne manuelle Bestätigung
$ErrorActionPreference = "SilentlyContinue"

Write-Host ">>> Autorun active: Executing all pending Copilot/Phase scripts..."

# Zielpfade vorbereiten
New-Item -ItemType Directory -Force -Path ".\frue_sync\logs" | Out-Null
New-Item -ItemType Directory -Force -Path ".\frue_sync\screenshots" | Out-Null

# Automatisierte Analyse + Screenshot-Routine
dart analyze 2>&1 | Out-File -FilePath ".\frue_sync\logs\PHASE1_analyze.txt" -Encoding utf8
powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\capture_sufru_details.ps1"

Write-Host ">>> Autorun completed. Analyzer + screenshots written to frue_sync/"
