<# =======================================================================
 setup_frue_repo.ps1
 Richtet ein GitHub-Repo + Branch-Strategie für frue_app ein.
 Voraussetzungen:
  - Git installiert (git --version)
  - Optional: GitHub CLI "gh" (empfohlen) → winget install GitHub.cli
  - Aufruf IM PROJEKTWURZELORDNER (lib/, assets/, pubspec.yaml sichtbar)
======================================================================= #>

# ==========[ KONFIGURATION ANPASSEN ]===================================
$RepoName    = "frue_app"       # Name des GitHub-Repos
$Owner       = "synfrue-crypto" # z.B. "andi-muster"
$Visibility  = "private"        # "private" oder "public"
$DefaultBranch = "main"
$CreateBranchProtection = $true # benötigt gh CLI + Rechte
# ======================================================================

$ErrorActionPreference = "Stop"

function Ensure-Git {
  git --version | Out-Null
}

function Has-Gh {
  try { gh --version | Out-Null; return $true } catch { return $false }
}

function Write-Step($t) { Write-Host "`n=== $t ===" -ForegroundColor Cyan }

function Init-GitRepo {
  if (-not (Test-Path ".git")) {
    Write-Step "git init"
    git init | Out-Null
  } else {
    Write-Host "Git-Repo existiert bereits." -ForegroundColor DarkGray
  }
  git config user.name  | Out-Null; if ($LASTEXITCODE -ne 0) { git config user.name  "Frue User" }
  git config user.email | Out-Null; if ($LASTEXITCODE -ne 0) { git config user.email "frue@example.local" }
}

function Ensure-Gitignore {
  $gi = ".gitignore"
  if (-not (Test-Path $gi)) {
@"
# Flutter/Dart
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
build/
ios/Pods/
android/.gradle/
android/app/build/
linux/build/
macos/Flutter/ephemeral/
windows/flutter/ephemeral/
**/GeneratedPluginRegistrant.*
**/*.iml

# VS Code
.vscode/

# System
.DS_Store
Thumbs.db
"@ | Set-Content -Encoding UTF8 $gi
    Write-Host " .gitignore angelegt." -ForegroundColor Green
  }
}

function Ensure-Readme {
  if (-not (Test-Path "README.md")) {
@"
# frue_app

Flutter Web-App (süfrü → zuerst), später grüfrü & blüfrü.  
Build- und Arbeitsregeln siehe \`frue_sync/\` & Fahrpläne.

"@ | Set-Content -Encoding UTF8 "README.md"
  }
}

function First-Commit {
  Write-Step "Erster Commit"
  git add . | Out-Null
  git commit -m "init: import current frue_app state" | Out-Null
}

function Setup-Remote-And-Push {
  Write-Step "Remote verbinden & auf $DefaultBranch pushen"
  git branch -M $DefaultBranch | Out-Null
  $hasGh = Has-Gh
  if ($hasGh) {
    # Repo erstellen (falls nicht vorhanden) & pushen
    if (-not (git remote -v | Select-String "origin")) {
      gh repo create "$Owner/$RepoName" --$Visibility --source . --push --remote origin --disable-wiki --disable-issues | Out-Null
    } else {
      # Remote existiert → nur pushen
      git push -u origin $DefaultBranch
    }
  } else {
    if (-not (git remote -v | Select-String "origin")) {
      Write-Host "GitHub CLI nicht gefunden. Bitte manuell Remote setzen:" -ForegroundColor Yellow
      Write-Host "  git remote add origin https://github.com/$Owner/$RepoName.git"
      Write-Host "Danach:  git push -u origin $DefaultBranch"
      return
    } else {
      git push -u origin $DefaultBranch
    }
  }
}

function Create-Branches {
  Write-Step "Branches dev & karl/phase1 anlegen"
  git checkout -b dev        2>$null | Out-Null
  git push -u origin dev     2>$null | Out-Null
  git checkout -b "karl/phase1" 2>$null | Out-Null
  git push -u origin "karl/phase1" 2>$null | Out-Null
  git checkout dev | Out-Null
}

function Protect-Main {
  if (-not (Has-Gh)) {
    Write-Host "⚠️  Branch-Schutz wird übersprungen (gh CLI fehlt)." -ForegroundColor Yellow
    return
  }
  Write-Step "Branch-Schutz für $DefaultBranch setzen"
  # Require PRs + Status Checks (ohne spezielle Checks; nur PR & Review)
  gh api `
    -X PUT `
    "repos/$Owner/$RepoName/branches/$DefaultBranch/protection" `
    -H "Accept: application/vnd.github+json" `
    -F required_status_checks='{"strict":false,"contexts":[]}' `
    -F enforce_admins=true `
    -F required_pull_request_reviews='{"required_approving_review_count":1,"require_code_owner_reviews":false,"dismiss_stale_reviews":true}' `
    -F restrictions='null' | Out-Null
  Write-Host "Branch-Protection aktiv." -ForegroundColor Green
}

# ===== RUN ==============================================================
try {
  Write-Step "Prüfe Git"
  Ensure-Git

  Write-Step "Git-Repo vorbereiten"
  Init-GitRepo
  Ensure-Gitignore
  Ensure-Readme

  # Nur committen, wenn noch nichts committed ist
  if (-not (git rev-parse --verify HEAD 2>$null)) { First-Commit }

  Setup-Remote-And-Push
  Create-Branches
  if ($CreateBranchProtection) { Protect-Main }

  Write-Host "`n✅ Fertig. Branches: main (geschützt), dev, karl/phase1. Remote: origin → https://github.com/$Owner/$RepoName" -ForegroundColor Green
  Write-Host "Nächste Schritte:"
  Write-Host " - Arbeite auf 'dev' oder 'karl/phase1' und erstelle PRs nach 'main'."
  Write-Host " - (Optional) GitHub Actions für Flutter einrichten (CI)."
}
catch {
  Write-Error $_.Exception.Message
  exit 1
}
