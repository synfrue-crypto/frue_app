
# frue_feinschliff_badge_v3.1

**Änderungen (systemweit, alle Marken):**
- Badge-Standardgröße: **28 px** (Variante A) für Bio/Demeter
- **+4 px** Abstand rechts vom Badge zum Produktnamen
- Produktkarte bleibt sonst unverändert; Preis rechts in Markenfarbe

**Dateien**
- `lib/widgets/badges.dart`
- `lib/widgets/product_card.dart`
- `lib/brand/brand_theme.dart` (unverändert, nur der Vollständigkeit halber)

**Einbau**
1. ZIP entpacken → Dateien ersetzen.
2. Assets in `pubspec.yaml` sicherstellen:
```
flutter:
  assets:
    - assets/icons/
    - assets/frue/images/
    - assets/data/
```
3. Neustart:
```
flutter clean
flutter pub get
flutter run -d chrome
```
