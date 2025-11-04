# App-Navigation (aus PDF konsolidiert)

## Hauptfluss
Home → Startseiten (Marken) → Shop Grid → Produkt-Detail → Warenkorb → Fulfillment → Checkout → Bestätigung

## Routen (Beispielnamen)
- `/home`
- `/brands` (Startseiten süfrü/grüfrü/blüfrü)
- `/shop/:brand` (Grid)
- `/product/:brand/:id` (Detail)
- `/cart`
- `/fulfillment`
- `/checkout`
- `/community` (Skeleton, v3)

## Sichtregeln
- Buttons nur aktiv, wenn Kontext erfüllt (z. B. Warenkorb > 0).
- Badges (bio/demeter) immer im Bild-Bereich eingeblendet.
- Grid passt sich Breakpoints an.
