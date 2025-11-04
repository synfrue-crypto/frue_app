PHASE 1 — SÜFRÜ STABIL + SCHÖN

Ziele (Akzeptanzkriterien mit Screenshot):
1) GRID
   - Badges (bio/demeter) UNTER dem Bild, links vor dem Produktnamen.
   - KEIN „Jetzt bestellen“-Button in der Karte (nur Bild, Name, Preis).
   - Assets via AssetRouter (jpg/jpeg/png), keine „assets/assets/...“-Dopplungen.
   - Chips aus category_name; Suchfeld funktionsfähig.
   -> Screenshot: screenshots/sufru_grid_ok.png

2) DETAIL
   - Ein zusammenhängender Textblock (fließend, keine Karten):
     Überschriften leicht fett. Reihenfolge:
       Beschreibung (long_desc)
       Herkunft (origin)
       Geschmack (taste)
       Reife / Saison (season)
       Allergene (allergens)
       Lagerung (storage)
       Anwendung (usage)
       Zertifikate (certificates)
       Transparenz / Tags (tags)
   - Bild oben groß, Menge/Preis rechts wie vorher (Stepper/Freimenge unverändert).
   -> Screenshot: screenshots/sufru_detail_ok.png

3) ASSETS
   - SmartAssetImage/AssetRouter so, dass folgende Kandidaten geprüft werden:
     assets/data/frue/images/<id>.jpg
     assets/data/frue/images/<id>.jpeg
     assets/data/frue/images/<id>.png
     assets/data/frue/images/placeholder.(png|jpg)
   - Keine doppelten Präfixe. Fallback greift.
   -> Log: logs/phase1_assets_fix.log

4) ANALYZE
   - dart analyze ohne neue Errors (Warnings ok).
   -> Log: logs/phase1_analyze.log
