import 'package:flutter/material.dart';
import '../theme/brand_theme.dart';
import '../widgets/smart_image.dart';
import '../services/data_loader.dart';
import '../shop/sufru/shop_list_page_sufru.dart';

class BrandHomeSufru extends StatelessWidget {
  const BrandHomeSufru({super.key});

  @override
  Widget build(BuildContext context) {
  const brand = 'sufru';
    final color = BrandTheme.colorFor(brand);

    Widget hero = AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: const SmartAssetImage([
          'START-SFRU-A0001',
        ], fit: BoxFit.cover),
      ),
    );

    Widget textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🍊 süfrü – Früchte mit Verantwortung',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(
          'Süfrü steht für ehrlichen Fruchtgenuss mit Haltung.\nWir bringen dir sonnengereifte Früchte direkt von verantwortungsvoll arbeitenden Betrieben aus Spanien – naturnah, saisonal und voller Geschmack. Jede Clementine, Orange oder Zitrone trägt ein Stück echter Handarbeit und Liebe zur Erde in sich.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
        ),
        const SizedBox(height: 12),
        Text(
          'Unsere Partnerbetriebe wirtschaften nachhaltig und fair – nach unseren eigenen Mindeststandards für ökologischen Anbau, Ressourcenschonung und soziale Verantwortung. Viele orientieren sich an Permakultur- oder Demeter-Prinzipien, alle jedoch mit dem Ziel, Böden, Wasser und Menschen zu achten.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
        ),
        const SizedBox(height: 12),
        Text(
          'Wir verzichten bewusst auf Reifekammern, Zwischenhändler und überflüssige Transportwege. Stattdessen setzen wir auf kurze, transparente Lieferketten und eine Kreislauflogik ohne Verschwendung: Überschüsse spenden wir, unverkäufliche Früchte werden verarbeitet. So entsteht echter Genuss mit gutem Gewissen.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
        ),
        const SizedBox(height: 12),
        Text(
          'Mit süfrü entscheidest du dich für Geschmack, Fairness und Nachhaltigkeit – im Einklang mit der Natur. 👉 Süfrü – weil Verantwortung besser schmeckt.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
        ),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          icon: const Icon(Icons.storefront_outlined),
          label: const Text('Shop öffnen', style: TextStyle(fontWeight: FontWeight.w700)),
          onPressed: () async {
            final products = await DataLoader.loadCatalogSufru();
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ShopListPageSufru(products: products)),
              );
            }
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('süfrü · Startseite')),
      body: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        if (w >= 900) {
          // Desktop: two-column layout
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: textColumn,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: hero,
                ),
              ],
            ),
          );
        }

        // Mobile / Tablet: stacked
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            hero,
            const SizedBox(height: 16),
            textColumn,
            const SizedBox(height: 24),
          ],
        );
      }),
    );
  }
}
