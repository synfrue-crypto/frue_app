# Visual diff report script
# Writes a short report comparing docs/screenshots_startseiten/sufru.png vs frue_sync/screenshots/brandhome_sufru_desktop.png
[Reflection.Assembly]::LoadWithPartialName('System.Drawing') | Out-Null

$root = Resolve-Path $PSScriptRoot\.. | Select-Object -ExpandProperty ProviderPath
$mockRel = "docs\screenshots_startseiten\sufru.png"
$captureRel = "frue_sync\screenshots\brandhome_sufru_desktop.png"
$mockPath = Join-Path $root $mockRel
$capturePath = Join-Path $root $captureRel
$logDir = Join-Path $root "frue_sync\logs"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$reportPath = Join-Path $logDir 'visual_diff_report.txt'

if (-not (Test-Path $mockPath)) { Write-Error "Mock not found: $mockPath"; exit 2 }
if (-not (Test-Path $capturePath)) { Write-Error "Capture not found: $capturePath"; exit 2 }

$fi1 = Get-Item $mockPath
$fi2 = Get-Item $capturePath
$img1 = [System.Drawing.Bitmap]::FromFile($mockPath)
$img2 = [System.Drawing.Bitmap]::FromFile($capturePath)
$w1 = $img1.Width; $h1 = $img1.Height
$w2 = $img2.Width; $h2 = $img2.Height

$stride = 4 # sample every 4th pixel to speed up
$diff = 0; $total = 0
$minx = [int]::MaxValue; $miny = [int]::MaxValue; $maxx = 0; $maxy = 0
$sw = [Diagnostics.Stopwatch]::StartNew()
$maxX = [Math]::Min($w1,$w2)-1
$maxY = [Math]::Min($h1,$h2)-1
for ($y=0; $y -le $maxY; $y += $stride) {
    for ($x=0; $x -le $maxX; $x += $stride) {
        $c1 = $img1.GetPixel($x,$y)
        $c2 = $img2.GetPixel($x,$y)
        if ($c1.R -ne $c2.R -or $c1.G -ne $c2.G -or $c1.B -ne $c2.B) {
            $diff++
            if ($x -lt $minx) { $minx = $x }
            if ($y -lt $miny) { $miny = $y }
            if ($x -gt $maxx) { $maxx = $x }
            if ($y -gt $maxy) { $maxy = $y }
        }
        $total++
    }
}
$sw.Stop()
if ($minx -eq [int]::MaxValue) { $minx = $miny = $maxx = $maxy = 0 }
$percent = [math]::Round(100.0 * $diff / $total, 2)

$summary = @()
$summary += "VISUAL DIFF REPORT - $(Get-Date -Format o)"
$summary += "Mock: $mockPath" + " -> ${w1}x${h1}, size=${($fi1.Length)} bytes"
$summary += "Capture: $capturePath" + " -> ${w2}x${h2}, size=${($fi2.Length)} bytes"
$summary += "Sample stride: $stride (every N-th pixel)"
$summary += "Sampled pixels: $total"
$summary += "Differing samples: $diff ($percent%)"
$summary += "Bounding sample box (approx): $minx,$miny to $maxx,$maxy"
$summary += "Comparison time: $($sw.Elapsed.TotalSeconds) s"

# Human-friendly interpretation
if ($percent -lt 3) { $summary += "Interpretation: Minor visual differences (likely small padding/antialias or compression)." }
elseif ($percent -lt 12) { $summary += "Interpretation: Moderate differences (layout or spacing changes visible)." }
else { $summary += "Interpretation: Major differences (content/structure likely different)." }

# Additional quick checks
if ($w1 -ne $w2 -or $h1 -ne $h2) {
    $summary += "Note: Dimensions differ; capture may have different viewport or scaling. Visual layout elements may be shifted." 
}

$summary | Tee-Object -FilePath $reportPath -Encoding utf8
$summary | ForEach-Object { Write-Host $_ }

# Dispose images
$img1.Dispose(); $img2.Dispose();

Write-Host "Wrote report to: $reportPath"