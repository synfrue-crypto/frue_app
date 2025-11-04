
# text_binding_patch_v2

- Badges (Bio/Demeter) **unter dem Produktnamen** via `brand_quality` + `certificates`.
- Dynamische Textfelder pro Shoptyp (sufru/grufru/blufru) mit Fallbacks (DE/EN Keys).
- Bild lädt .jpg/.png per SmartAssetImage (bereits vorhanden).
- Menge/Stepper bleibt erhalten.

## Dateien
- lib/widgets/badges.dart
- lib/shop/product_detail_page.dart

## Einbau
1) ZIP entpacken, Dateien übernehmen.
2) Sicherstellen, dass in pubspec.yaml die Assets eingebunden sind:
   - assets/icons/bio.png
   - assets/icons/demeter.png
3) Neu starten:
   flutter clean
   flutter pub get
   flutter run -d chrome
