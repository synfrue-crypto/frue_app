
# frue_shop_fix_badge_grid_v3.2

Fixes:
- **Badges** (Bio/Demeter) wieder sichtbar: kein `const`, Qualität aus Produkt übergeben.
- **Stabile Bilder beim Filtern**: Grid-Kacheln bekommen `ValueKey` (id-basiert).
- **Chip-Farben**: `BrandTheme.chipThemeFor` wieder enthalten.

Dateien:
- lib/brand/brand_theme.dart
- lib/widgets/product_card.dart
- lib/shop/shop_list_page.dart

Einbau:
1) ZIP entpacken, Dateien ersetzen.
2) `flutter clean && flutter pub get && flutter run -d chrome`
