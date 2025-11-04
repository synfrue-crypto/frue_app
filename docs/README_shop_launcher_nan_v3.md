
# shop_launcher_nan_sanitizer_fix_v3

**Problem:** Kataloge lassen sich nicht laden wegen `NaN` in JSON (`FormatException: ... Unexpected token 'N'`).  
**Fix:** Der ShopLauncher saniert die Roh-JSON-Strings vor dem `json.decode`:
ersetzt `NaN`, `Infinity`, `-Infinity` → `null` (gültiges JSON).

**Zusätzlich:**
- Normalisiert Marken (`süfrü→sufru`, `grüfrü→grufru`, `blüfrü→blufru`).
- Probiert mehrere Assetpfade nacheinander.
- Saubere Konvertierung in `List<Map<String,dynamic>>`.
- Debug-Logs: `ShopLauncher: loaded/failed ...`

## Datei
- lib/brand/shop_launcher.dart (Ersetzen)

## Schritte
1) ZIP entpacken → Datei ersetzen.
2) Neustart:
   flutter clean
   flutter pub get
   flutter run -d chrome
3) Debug-Konsole prüfen: sollte `ShopLauncher: loaded assets/data/catalog_sufru.json` zeigen.
