
# Grüfrü Detail-Layout v1

- Kartenlayout wie im Mockup
- Für **grüfrü**: **kein Produktbild**, Fokus auf Textabschnitte + Preis/CTA rechts
- Neue Sektion **"Labor"** (Laborwerte) unter **Zusammensetzung**
- Responsiv: einspaltig (mobil) / zweispaltig (breit)

## Einbau
Ersetze deine `lib/shop/product_detail_page.dart` durch diese Version.

## Felder (aus JSON)
- Beschreibung: `long_desc|beschreibung|short_desc|description`
- Anwendung: `usage|anwendung|zubereitung|verwendung`
- Zusammensetzung: `composition|zusammensetzung|ingredients|bestandteile`
- **Laborwerte:** `labor|laborwerte|lab`
- Transparenz generiert aus `brand`, `category_name|category`, `tags`

Für süfrü/blüfrü bleibt das Bild sichtbar, für grüfrü automatisch ausgeblendet.
