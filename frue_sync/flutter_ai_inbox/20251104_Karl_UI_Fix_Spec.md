[READY]
# KARL · UI/UX FIX SPEC · SÜFRÜ FIRST (SAFE MODE)

Kontext
- Projektordner: ./frue_app/
- Safe-Mode: ON (keine externen Systeme, keine Design-Experimente, nur Fix + vereinbarte Optik)
- Shops: Fokus **süfrü** (grüfrü/ blüfrü später), **keine Shop-Splittung** vornehmen.

## ZIELE (SÜFRÜ)
1) **Assets-Fix**
   - Fehlerbild: doppelte Präfixe wie `assets/assets/...` und fehlende Dateiendungen.
   - Verhalten: Bilder liegen unter `assets/data/frue/images/` und heißen z. B. `SFRU-001-A0001.jpg` (mehrheitlich .jpg, teils .png).
   - Lösung: zentralen **AssetRouter** (oder bestehende SmartImage-Lösung) so anpassen, dass folgende Mapping-Regeln gelten:
     - Eingang: reine `asset_id` (z. B. `SFRU-001-A0001`) **ohne** Unterpfad & **ohne** Endung.
     - Build-Pfade dynamisch prüfen in dieser Reihenfolge (exist check):  
       1) `assets/data/frue/images/{id}.jpg`  
       2) `assets/data/frue/images/{id}.jpeg`  
       3) `assets/data/frue/images/{id}.png`  
       4) Fallback: `assets/data/frue/images/placeholder.jpg` (oder `.png`, was vorhanden ist)
     - **Wichtig:** niemals `assets/assets/...` erzeugen.
   - Betroffene Dateien: `lib/widgets/smart_image.dart` (oder `lib/utils/asset_router.dart` – je nachdem, was im Projekt aktiv ist).

2) **Badge (bio/demeter)**
   - Quelle: im Katalogfeld **brand_quality** (Wert: "bio" oder "demeter").
   - Anzeige-Regel: 
     - Icon-Dateien liegen unter `assets/icons/` als `bio.png` bzw. `demeter.png`.
     - Im Grid **rechts oben** auf der Karte, sichtbar groß (wie zuletzt gewünscht), im Detailbereich oben beim Titel.
   - Betroffene Dateien: `lib/widgets/product_card.dart`, `lib/shop/sufru/product_detail_page_sufru.dart`.

3) **Filterchips & Suche**
   - Filterchips zeigen **Kategorie-Namen** (aus `category_name`) – NICHT „CAT01 …“ (das ist nur die ID).
   - Erste Option: „Alle“.
   - Suche: einfacher Textfilter auf `name` (optional, falls Komplexität verhindert – aber bitte platzieren).
   - Betroffene Datei: `lib/shop/sufru/shop_list_page_sufru.dart`.

4) **Detailseite (Texte laden)**
   - Zeige unter dem Bild und Titel, in EINEM Block untereinander (keine verstreuten Mini-Widgets):
     - **Beschreibung**: `long_desc`
     - **Anwendung**: `Anwendung`
     - **Zusammensetzung**: `Composition`
     - (Die anderen Felder bei süfrü sind aktuell nicht Pflicht – nur sauber verfügbar halten)
   - Überschriften etwas fetter; ansonsten an der bestehenden, „schicken“ Variante orientieren.
   - Betroffene Datei: `lib/shop/sufru/product_detail_page_sufru.dart`.

5) **Stepper & Freimenge**
   - Allgemein: Standard-Step aus `qty_step` (falls leer → 1.0).
   - Sonderfall süfrü: **CAT04** hat zwei Produkte mit `0,25`-Schritten: **SFRU-012**, **SFRU-015**.
     - Der Stepper akzeptiert also in diesen Fällen 0.25-Schritte.
   - Zusätzlich ein Feld „Freimenge“ (benutzereingabe), die zum Bestellwert addiert wird (nur positive Zahl, leer = 0).
   - Betroffene Datei(en): `lib/widgets/quantity_input.dart`, `lib/shop/sufru/product_detail_page_sufru.dart`.

6) **Kein Design-Experiment**
   - Bitte **keine neuen Komponenten**, **keine Shop-Splittung**, **keine Theme-Umbauten**.
   - Nur die oben beschriebenen Fixes im existierenden Layout („schicke“ Variante beibehalten).

---

## TECHNISCHE UMSETZUNG
- Patches als vollständige Dateien ausgeben (keine Mini-Diff-Stücke), in: `frue_sync/flutter_ai_inbox/`.
- Dateinamen: exakt wie Ziel (`product_card.dart`, `shop_list_page_sufru.dart`, …).
- Zusätzlich jeweils ein `.patch.txt` mit Kurzbegründung.

---

## AKZEPTANZKRITERIEN (SÜFRÜ)
1. **Assets**: Keine 404 im Browser-Log. Pfade ohne Doppel-„assets“. Platzhalter greift, wenn Bild fehlt.
2. **Badge**: Bio/Demeter-Icon sichtbar & korrekt (Grid oben rechts + Detail oben beim Titel).
3. **Filterchips**: Anzeigen `category_name` (deutsch), inkl. „Alle“. Filter arbeitet korrekt.
4. **Detailtexte**: `long_desc`, `Anwendung`, `Composition` erscheinen untereinander in einem Block.
5. **Mengenlogik**: Stepper respektiert `qty_step`; Sonderfälle SFRU-012/015 mit 0.25; Freimenge-Feld funktioniert.
6. **Kein Regression**: Startseite → süfrü-Grid → Produktdetail → Warenkorb (falls vorhanden) ohne neue Fehler.

---

## VALIDIERUNG
- `dart analyze` → 0 Errors (Warnings erlaubt)
- `flutter run -d chrome` → App startet, süfrü Shop zeigt Produkte inkl. Bilder/Badges/Filter/Detailtexte.
- Logfile erzeugen: `20251104_karl_sufru_fix.log` mit
  - geänderten Dateien
  - Analyzer-Status
  - kurzer Self-Check-Ausgabe

[END]
