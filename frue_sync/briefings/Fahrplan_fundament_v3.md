# Fahrplan · Fundament V3 — Community Skeleton + Profil (ohne externe Writes)

**Stand**: 2025-11-04  
**Ziel**: Nutzerlogin + Profil-Stubs, Community-Home mit 6 Sektionen (leer, klickbar).  
**Safe-Mode**: Keine Drive/Firestore-Schreibvorgänge.

## Aufgaben
1) **Auth UI**
   - Screens: Login, Registrieren, Passwort-Reset (UI-Stubs).
   - State nur lokal (Mock), später austauschbar gegen Firebase.
2) **Profil**
   - Profilseite mit Feldern: Name, E-Mail, Telefon, Standard-Abholort.
   - Nur lokale Speicherung (app state); keine externen Writes.
3) **Community-Home**
   - 6 Sektionen (Platzhalter): Ankündigungen, Fragen & Hilfe, Wissen, Aktionen, Events, Profil.
   - Navigation vorbereitet; Inhalte später.
4) **Design**
   - Warm, freundlich; Brand-Tokens aus `brand_themes.md`.

## Abnahme
- Navigation vollständig, keine toten Enden.
- Kein Einfluss auf SÜFRÜ-Shop-Fluss.
