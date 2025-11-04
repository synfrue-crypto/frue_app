# Plug & Work Paket – frü App Shops (V1)

Dieses Paket bringt eine **modulare Shop-Struktur**, ohne das Verhalten/Design zu verändern.
Alles bleibt funktionsgleich – nur die Dateien sind sauber nach Marken getrennt.

## Neue Pfadstruktur

```
lib/shop/
├─ sufru/
│  ├─ shop_list_page_sufru.dart
│  └─ product_detail_page_sufru.dart
├─ grufru/
│  ├─ shop_list_page_grufru.dart
│  └─ product_detail_page_grufru.dart
└─ blufru/
   ├─ shop_list_page_blufru.dart
   └─ product_detail_page_blufru.dart
```

> **Hinweis:** blüfrü ist als Platzhalter vorbereitet („Im Aufbau“).

## Launcher

`brand/shop_launcher.dart` importiert jetzt die modularen Seiten.
Die Navigation bleibt identisch; lediglich die Zuweisung erfolgt markenspezifisch.

## Einwurf

1. Dieses Paket ins Projekt entpacken (Dateien überschreiben erlauben).
2. `flutter pub get`
3. Starten wie gewohnt (`flutter run`)

Safe-Mode bleibt aktiv (keine externen Zugriffe).
