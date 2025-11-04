
# Assets einbinden (Bilder & Badges)

1) **Produktbilder**
   - In deinem `catalog.json` sind Pfade wie `assets/frue/images/...jpg` hinterlegt.
   - Diese Bilder müssen im Projekt liegen und in `pubspec.yaml` eingebunden sein.

   ```yaml
   flutter:
     assets:
       - assets/frue/images/
       - assets/icons/
   ```

2) **Badges (Bio/Demeter)**
   - Lege die Dateien unter `assets/icons/` ab:
     - `assets/icons/bio.png`
     - `assets/icons/demeter.png`

3) **Neu laden**
   ```powershell
   flutter clean
   flutter pub get
   flutter run -d chrome
   ```
