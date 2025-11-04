# Patch V1 – Badges & Brand-Logo

Dateien:
- `lib/widgets/badges.dart` – erzeugt Badge-Chips (Demeter/Bio) aus Produktfeldern.
- `lib/widgets/product_card.dart` – Overlay-Icon + Chips & Einheiten-/Preiszeile.
- `lib/shop/product_detail_page.dart` – zeigt ebenfalls die Badge-Chips.
- `lib/shop/shop_list_page.dart` – AppBar mit Brand-Logo (Pfad: `assets/brand/<brand>_logo.png`).

`pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/frue/images/
    - assets/icons/
    - assets/brand/
```
Assets erwartet:
```
assets/icons/bio.png
assets/icons/demeter.png
assets/brand/sufru_logo.png
assets/brand/grufru_logo.png
assets/brand/blufru_logo.png
```

Neustart:
```
flutter clean
flutter pub get
flutter run -d chrome
```