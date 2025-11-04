# apply_karl_patches.ps1
$ErrorActionPreference = "Stop"

# 0) Vorbedingungen
if (-not (Test-Path ".\pubspec.yaml")) { throw "Bitte im Projektwurzelordner ausführen (mit pubspec.yaml)." }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "Git nicht gefunden. Bitte Git installieren und im PATH verfügbar machen." }

$inbox = "frue_sync/flutter_ai_inbox"
if (-not (Test-Path $inbox)) { throw "Inbox-Ordner '$inbox' nicht gefunden." }

$stamp = (Get-Date).ToString("yyyyMMdd_HHmmss")

# 1) Backup & Git-Branch
Write-Host "==> Backup & Branch…" -ForegroundColor Cyan
$backupZip = "backup_before_karl_$stamp.zip"
Compress-Archive -Path * -DestinationPath $backupZip -Force
if (-not (Test-Path ".git")) { git init | Out-Null }
git add -A
git commit -m "Snapshot before Karl patches ($stamp)" | Out-Null
git checkout -b "karl-fixes-$stamp" | Out-Null

# 2) Patches anwenden
Write-Host "==> Patches anwenden…" -ForegroundColor Cyan
$log = "apply_karl_patches_$stamp.log"
New-Item -ItemType File -Path $log -Force | Out-Null

# Alle *.patch*.txt und *.patch* durchgehen (Karl benennt manchmal leicht anders)
$patchFiles = Get-ChildItem $inbox -Recurse -Include *.patch*,*.diff* | Sort-Object Name
if ($patchFiles.Count -eq 0) { throw "Keine Patch-Dateien in $inbox gefunden." }

foreach ($p in $patchFiles) {
  Write-Host " - $($p.Name)"
  Add-Content $log "`n=== Applying: $($p.FullName) ===`n"
  # Erst normal versuchen
  git apply --ignore-whitespace --whitespace=fix --verbose $p.FullName 2>&1 | Tee-Object -FilePath $log -Append
  if ($LASTEXITCODE -ne 0) {
    Write-Host "   -> 3-way Fallback" -ForegroundColor Yellow
    # 3-way Merge Fallback
    git apply --3way --ignore-whitespace --whitespace=fix --verbose $p.FullName 2>&1 | Tee-Object -FilePath $log -Append
    if ($LASTEXITCODE -ne 0) {
      Write-Host "   !! Patch konnte nicht automatisch angewendet werden. Siehe $log" -ForegroundColor Red
      throw "Patch-Fehler bei $($p.Name)"
    }
  }
}

# 3) Abhängigkeiten & Build
Write-Host "==> Flutter clean & get…" -ForegroundColor Cyan
flutter clean
flutter pub get

Write-Host "==> Smoke-Run (Chrome) starten…" -ForegroundColor Cyan
flutter run -d chrome
