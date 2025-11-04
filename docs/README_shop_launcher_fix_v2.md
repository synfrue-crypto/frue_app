
# shop_launcher_fix_v2

**Problem:** Nach dem letzten Patch sind Shop-Seiten leer.
**Ursache:** Brand-String/Asset-Pfad passte nicht exakt oder JSON-Typkonvertierung schlug still fehl.

**Fix:**
- Normalisiert Marken: 'süfrü' → 'sufru', 'grüfrü' → 'grufru', 'blüfrü' → 'blufru'.
- Probiert mehrere Asset-Pfade nacheinander.
- Robuste JSON-Map-Konvertierung (sichert Map<String,dynamic>).
- Debug-Logs in der Konsole (ShopLauncher: loaded/failed ...).

## Datei
- lib/brand/shop_launcher.dart (Ersetzen)

## Schritte
1) ZIP entpacken → Datei ersetzen.
2) Neu starten:
   flutter clean
   flutter pub get
   flutter run -d chrome
3) Im Debug-Log prüfen: "ShopLauncher: loaded assets/data/catalog_*.json"
