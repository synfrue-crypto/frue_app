# Fahrplan · Fundament V2 — Vorbereitung GRÜFRÜ/BLÜFRÜ (modular)

**Stand**: 2025-11-04  
**Ziel**: SÜFRÜ bleibt stabil. GRÜFRÜ/BLÜFRÜ nur vorbereitet (Baustellenschild), Code modular.

## Aufgaben
1) **ShopLauncher**
   - Markenrouting: `sufru` → Grid + Detail (fertig), `grufru`/`blufru` → Baustellenseite.
2) **Modularisierung**
   - Dateien sauber je Marke (ohne Verhalten ändern).
   - Gemeinsame Widgets zentral: ProductCard, SmartAssetImage, QuantityInput.
3) **Baustellenschild**
   - Schlichte Seite mit Hinweis „Im Aufbau – bald verfügbar“.
   - Theme-Farben je Marke anwenden.

## Daten & Router
- Asset-Router: akzeptiert `.jpg|.jpeg|.png`; Präfixe doppelt vermeiden.
- Keine Netz-Abhängigkeiten.

## Abnahme
- SÜFRÜ unverändert nutzbar.
- GRÜFRÜ/BLÜFRÜ erscheinen nicht kaputt (nur Platzhalter).
