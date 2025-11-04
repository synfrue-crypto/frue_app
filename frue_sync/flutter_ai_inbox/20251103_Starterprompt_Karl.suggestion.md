[READY]
# Projektstart: Frü App – Shop-Reparatur & Stabilisierung (süfrü, grüfrü, blüfrü)

## Kontext
- Projekt: Frü App
- Hauptordner: ./frue_app/
- Sync-Ordner: ./frue_sync/
- Aktiver Safe-Mode: ON
- Federführung: Rio (GPT-5)
- Ausführend: Flutter AI (Karl)
- Ziel: Stabilisierung der Shop-Module

## Aufgabenbeschreibung
Führe eine **vollständige Analyse und Reparatur** der bestehenden Flutter-App durch:

### Ziel 1 – Shops (Priorität A)
1. Prüfe und stabilisiere:
   - `lib/shop/sufru/`  → funktionsfähig, optisch intakt
   - `lib/shop/grufru/` → Fehler beheben, keine UI-Änderung
   - `lib/shop/blufru/` → Dummyseite „Im Aufbau“
2. Entferne doppelte oder fehlerhafte Importe (`brand_theme`, `asset_router`, …).
3. Behebe alle Build- und Analyzer-Fehler (`dart analyze`).
4. Führe eine *dry run*-Simulation (`flutter run --verbose`) durch (keine externen Zugriffe).
5. Dokumentiere Änderungen als `.patch.txt` Dateien in  
   `/frue_sync/flutter_ai_inbox/` (Template: `fix.patch.txt`).

### Ziel 2 – Stabilität
- Keine neuen Funktionen oder Designs.
- Nur logische und technische Korrekturen (Pfadfehler, Imports, Typkonflikte).
- **Assets müssen auf** `assets/data/frue/images/` **zeigen** (jpg **und** png akzeptieren).

### Ziel 3 – Validierung
Nach Abschluss:
- Erzeuge eine Datei `20251103_buildreport_karl.build_log.txt` mit:
  - Analyzer-Status (vor/nach Fix)
  - Geänderte Dateien
  - Ergebnis (Status: SUCCESS/FAIL)

## Output-Erwartung
- 1× Fix-Patch pro betroffene Datei in `/frue_sync/flutter_ai_inbox/`
- 1× `buildreport_karl.build_log.txt`
- Keine automatischen Commits oder Builds
