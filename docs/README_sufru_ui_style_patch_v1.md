
# süfrü UI Style Patch v1

- **Kategorie-Filter (Chips)** oben im Shop-Grid: basiert auf `category_name`.
- **Badges** (Bio/Demeter) jetzt **Icon-only** und größer (Detailseite links neben dem Titel).
- **Detail-Headlines** fetter (`titleMedium` + bold).
- Allgemeine Kosmetik & Abstände, keine Logikänderungen.

## Dateien
- lib/widgets/badges.dart
- lib/shop/product_detail_page.dart
- (Optional Beispiel) lib/shop/shop_list_page.dart  *falls du eine eigene hast, nur die Kategorie-Chips-Logik übernehmen.*

## Schritte
1) ZIP entpacken, Dateien einfügen/ersetzen.
2) Prüfen, dass `assets/icons/` in der pubspec eingebunden ist.
3) Neu starten:
   flutter clean
   flutter pub get
   flutter run -d chrome
