🧭 FRÜ_APP – KARL UNIVERSAL TASK
----------------------------------------
🪴 Projektmodul: Shop-Startseiten (süfrü, grüfrü, blüfrü)
Version: 2025-11-04_V1
Ziel: Aufbau und Gestaltung der drei markenspezifischen Startseiten laut Design- und Textvorgaben.

----------------------------------------
📋 ANWEISUNG
Karl, bitte folgende Aufgabe ausführen:

1. Lies die beigefügten Dokumente:
   - suefrue_gruefrue_homepage_texte_final.txt
   - bluefrue_homepage_text_final_v2.txt
   - startseite shops.pdf
   - frue_app_navigation.pdf

2. Erstelle die Startseiten der drei Marken in Flutter unter:
   ```
   lib/brand/
   ├─ brand_home_sufru.dart
   ├─ brand_home_grufru.dart
   └─ brand_home_blufru.dart
   ```
   und aktualisiere `brand_home_page.dart` für die Navigation.

3. Anforderungen pro Marke:
   - **süfrü:** Vollständige Startseite (Hero-Bild + Textblöcke + CTA)
   - **grüfrü:** Vereinfachte Startseite (Hero + CTA „Shop öffnen“)
   - **blüfrü:** Baustellenschild mit Platzhalter-Text und 🌼-Icon

4. Stilrichtlinie:
   - Design & Farben laut BrandTheme (siehe Designrichtlinie Community Module .txt)
   - Typografie warm, freundlich, klar (nach frue_app_neuaufbau_v1.txt)
   - Responsiv (Hero-Bild oben, Text darunter fließend)
   - Hero-Bilder:
     ```
     assets/data/frue/images/START-SFRU-A0001.jpg
     assets/data/frue/images/START-GFRU-A0001.jpg
     assets/data/frue/images/START-BFRU-A0001.jpg
     ```
   - CTA: zentriert, Farbe nach Brand (süfrü=gelb, grüfrü=grün, blüfrü=blau)

5. Verlinkungen:
   - CTA „Shop öffnen“ → jeweiliger Shop-Grid
   - Footer-Link „Über [Marke]“ → Platzhalterseite (noch leer lassen)

6. Validierung:
   - Keine Fehler im Build (`flutter run -d chrome`)
   - Keine Änderungen an Cart, Checkout oder Drive
   - Alle Texte deutschsprachig aus den Quellen übernehmen
   - Safe-Mode aktiv (keine externen Requests)

----------------------------------------
✅ ERWARTETES ERGEBNIS
Nach Fertigstellung sollen:
- Alle drei Startseiten funktionsfähig und erreichbar sein.
- süfrü voll gestaltet sein (Texte, Bilder, CTA).
- grüfrü minimal aufgebaut mit aktivem CTA.
- blüfrü mit Baustellenseite und Claim „Hier wächst bald etwas Schönes 🌼“.
- Navigation von der Hauptseite (brand_home_page.dart) aus funktionieren.

----------------------------------------
🔁 ABSCHLUSS
Nach Fertigstellung:
→ Speichere Build-Report unter `/frue_sync/buildreport_startseiten.txt`
→ Screenshot-Verzeichnis anlegen: `/docs/screenshots_startseiten/`

----------------------------------------
#safe #buildready #task #karl #frue_systemhaus
