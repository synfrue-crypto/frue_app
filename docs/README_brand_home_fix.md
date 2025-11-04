
# brand_home_page Fix (products Übergabe)

Dieses Patch löst den Fehler
> Required named parameter 'products' must be provided (ShopListPage)

Indem die Brand-Startseite beim Klick auf "Zum Shop" zuerst eine kleine
`ShopLauncher`-Seite öffnet, die die richtigen `catalog_*.json` Assets lädt
und danach `ShopListPage(brand: ..., products: [...])` rendert.

## Dateien
- lib/brand/brand_home_page.dart   (ersetzt)
- lib/brand/shop_launcher.dart     (neu)

## Schritte
1) ZIP entpacken → Dateien ins Projekt kopieren/ersetzen.
2) Sicherstellen, dass in `pubspec.yaml` die Assets eingebunden sind:
   - assets/data/catalog_sufru.json
   - assets/data/catalog_grufru.json
   - assets/data/catalog_blufru.json
3) Neustart:
   flutter clean
   flutter pub get
   flutter run -d chrome
