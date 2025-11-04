
# Frü · Orders → Google Sheets (V2)

**Spreadsheet-ID (von dir):** `14YRwwJuLdRr97b36tu5BI6c3KTGQsgIyuEoLijuikNE`

Tabs je Shop (werden automatisch angelegt, falls nicht vorhanden):
- `sufru_bestellungen`
- `grufru_bestellungen`
- `blufru_bestellungen`

## Setup
1) Apps Script: Inhalt aus `tools/gs/orders_webapp_v2.gs` einfügen (ID ist bereits gesetzt).
   - Veröffentlichen → Als Web-App → Jeder mit dem Link → URL kopieren.
2) Flutter: `lib/core/order_service.dart` integrieren, in `main()` `await OrderService.init();`
   - In `config/.env`: `ORDER_ENDPOINT=<WebApp URL>`
3) Checkout-Integration: `lib/shop/checkout_customer_integration.patch.txt` befolgen
   (Dialog mit Name/E-Mail/Telefon öffnet sich, dann POST an WebApp).

## Gebühren & Hinweis
- fulfillment.id beginnt mit `delivery_` → **5,00 €**
- fulfillment.id == `delivery_versand` → **8,50 €**
- Notiz wird automatisch mitgeschrieben: *„Preis ist ein Richtwert. Finale Summe nach Wiegen/Packen.“*
