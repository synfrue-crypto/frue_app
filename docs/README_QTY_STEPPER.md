
# Qty-Stepper Patch V1 (0.25 / 0.5 / frei)

- Unterstützt **produktabhängige Steps** über Felder: `qty_step`, `step`, `increment`, `min_qty`, `pack_size`.
- Fallbacks: `kg` → 0.5; `stk`/`l` → 1.0.
- **Freie Eingabe** per Textfeld (z. B. `10` für 10 kg). Beim Bestätigen wird auf Step-Einheiten gemappt.
- Im Warenkorb bleibt die Logik unverändert: es werden „Einheiten“ der Stepgröße gezählt.

## Einbau
1. Ersetze Dateien:
   - `lib/widgets/product_card.dart`
   - `lib/shop/product_detail_page.dart`
2. `flutter clean && flutter pub get && flutter run -d chrome`

## Hinweis
Wenn du zwei süfrü-Artikel mit `0.25 kg` hast, füge in deren Katalogeinträgen **`"qty_step": 0.25`** hinzu – der UI-Stepper übernimmt das automatisch.
