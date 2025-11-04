import 'package:flutter/material.dart';
import '../theme/brand_theme.dart';
import '../widgets/smart_image.dart';
import '../shop/grufru/shop_list_page_grufru.dart';

class BrandHomeGrufru extends StatelessWidget {
  const BrandHomeGrufru({super.key});

  @override
  Widget build(BuildContext context) {
  const brand = 'grufru';
    final color = BrandTheme.colorFor(brand);

    return Scaffold(
      appBar: AppBar(title: const Text('grüfrü · Startseite')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: SmartAssetImage(const [
              'START-GFRU-A0001',
            ], fit: BoxFit.cover, borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 16),
          Text('🌿 grüfrü – Böden, Kreisläufe, Zukunft',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            'Grüfrü steht für gesunde Böden, natürliche Pflanzenkraft und echte Kreislaufwirtschaft.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 12),
          Text(
            'Unsere Jauchen, Dünger und Substrate entstehen aus naturreinen Inhaltsstoffen – handgemacht, ressourcenschonend und frei von Chemie. Sie fördern das Bodenleben, stärken Mikroorganismen und unterstützen den Humusaufbau.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 12),
          Text(
            'Wir glauben an Kreisläufe statt Abhängigkeit. Grüfrü arbeitet nach den Prinzipien von Zero Waste und Offgrid – energieautark, regional und mit vollständiger Rückführung aller Stoffe. Solarenergie, Regenwassernutzung und wiederverwertete Materialien sind fester Bestandteil unserer Arbeit.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 12),
          Text(
            'Unsere Rezepturen verbinden traditionelles Wissen mit moderner Forschung. Jede Charge wird sorgfältig hergestellt und laborgeprüft, um Wirksamkeit und Qualität sicherzustellen. Grüfrü steht für Vertrauen, Transparenz und handwerkliche Präzision – von der Pflanze bis zum Boden.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 12),
          Text(
            'Für alle, die Verantwortung übernehmen – im Garten, auf dem Feld oder in der Gemeinschaft. 👉 Grüfrü – weil Zukunft im Boden wächst.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 18),
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
              icon: const Icon(Icons.eco_outlined),
              label: const Text('Shop öffnen', style: TextStyle(fontWeight: FontWeight.w700)),
              onPressed: () {
                // Navigate to grufru shop page; ShopListPageGrufru will load local catalog if products empty
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopListPageGrufru(brand: 'grufru', products: [])),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
