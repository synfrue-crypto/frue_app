
# Resilient Paths Patch (DataLoader)

Behebt 404/Asset-Pfad-Probleme bei Flutter Web:
- Versucht mehrere Kandidatenpfade (z. B. `assets/data/catalog_<brand>.json`, `assets/data/catalog.json`, ...).
- Loggt in die Browser-Konsole, welcher Pfad tatsächlich gefunden wurde.
- Enthält weiterhin die NaN/Infinity-Sanitisierung.

## Einbau
1) Ersetze `lib/core/data_loader.dart` durch die Datei aus diesem ZIP.
2) Prüfe in `pubspec.yaml`, dass die Asset-Ordner eingebunden sind:
```yaml
flutter:
  assets:
    - assets/data/
    - assets/frue/images/
    - assets/icons/
    - assets/brand/
```
3) Stelle sicher, dass mind. **einer** der folgenden Dateien existiert (pro Marke):
```
assets/data/catalog_sufru.json  (oder)  assets/data/catalog.json
assets/data/fulfillment_sufru.json  (oder)  assets/data/fulfillment.json
```
4) Neu starten:
```
flutter clean
flutter pub get
flutter run -d chrome
```
Im Browser `F12` → Konsole: dort steht, welche Datei geladen wurde.
