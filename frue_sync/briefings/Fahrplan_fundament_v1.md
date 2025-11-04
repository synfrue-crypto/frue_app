# Fahrplan · Fundament V1 — SÜFRÜ Kern (Grid, Detail, Warenkorb, Checkout)

**Stand**: 2025-11-04  
**Ziel**: SÜFRÜ-Shop stabil & „schön“, ohne externe Abhängigkeiten (kein Drive/Firestore).  
**Design**: gemäß `frue_sync/system/Designrichtlinie_Core.md` + `brand_themes.md`.

## Aufgaben
1) **Grid SÜFRÜ**
   - Filterchips: Kategorien aus `category_id/category_name`.
   - Produktkarte: Bild (Asset-Router), Produktname (zentriert, 2-zeilig), Preis, Einheit.
   - Badge (bio/demeter) **im Bild** rechts unten.
   - Responsive Grid (XS 1, SM 2, MD 3, LG 4).
2) **Detail SÜFRÜ**
   - Bild oben (Asset-Router), darunter **ein** Block mit Texten:
     - Beschreibung (`long_desc`), Herkunft (`origin`), Geschmack (`taste`), Reife/Saison (`season`),
       Allergene (`allergens`), Lagerung (`storage`), Anwendung (`usage`),
       Zertifikate (`certificates`), Transparenz/Tags (`tags`).
   - Stepper: `qty_step` (SFRU-012/015 = 0,25), Freimenge-Feld erlaubt.
   - „Zum Warenkorb“ → Cart (kein Popup).
3) **Cart/Checkout**
   - Cart → `FulfillmentSelectorPage` → Checkout (bereits vorhanden).
   - Hinweis: Preis ist Richtwert; final beim Packen/Wiegen.
4) **Sauberkeit**
   - Keine Dropins; ganze Dateien ersetzen.
   - Alle Änderungen loggen unter `frue_sync/logs/`.

## Daten
- Kataloge unter `assets/data/catalog_*.json` (lokal).
- Bilder unter `assets/data/frue/images/` (jpg/png/jpeg, via Asset-Router).

## Abnahme
- Lighthouse-like Quickcheck (nur Gefühl): Layout, Kontrast, Klickpfade.
- Kein neues UI-Konzept; nur „schön + stabil“.
