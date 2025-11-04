Startnachricht für Karl (kopieren & in Karl posten)

Titel: Phase AUTH · Lokales Profil einhängen (ohne Firebase), keine Shop-Änderungen
Aufgaben (ohne Nachfragen ausführen, Safe-Mode: lokale Dateien ok):

Routes verkabeln:

In lib/main.dart oder eurer zentralen Router-Stelle eine Route '/profile' → ProfileEntry() registrieren:

import 'profile/profile_entry.dart';
// ...
routes: {
  ProfileEntry.route: (context) => const ProfileEntry(),
  // bestehende Routen unverändert lassen
}


In der Startseite (Home) einen schlichten Button oder Menüpunkt „Nutzerprofil“ einfügen, der zu ProfileEntry.route navigiert. Design: BrandTheme (süfrü, warm).

Keine Firebase-Pakete installieren. Diese Stufe ist lokal – reine UI/Service-Schicht.

Checkout-Brücke vorbereiten (nur wenn vorhanden, sonst überspringen):

Falls im Checkout (oder Fulfillment) Kundendaten benötigt werden, liefer AuthService.instance.currentUser dort an, ohne Pflicht zu machen.

Linter/Analyze laufen lassen und Fehler beheben, ohne Shops zu berühren.

Build-Test (Chrome/Web) starten und im Log bestätigen, dass /profile erreichbar ist.

Erfolgskriterien:

Shops (süfrü) unverändert funktionsfähig.

Route /profile erreichbar.

„Lokale Anmeldung“ funktioniert: Name/E-Mail/Telefon setzen und im Profil sehen.

Keine neuen Abhängigkeiten, keine Firebase-Konfiguration erforderlich.

Nächste Phase (morgen): Firebase Auth + persistentes Profil + Checkout-Prefill (separater Auftrag).