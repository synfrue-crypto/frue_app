import 'package:flutter/material.dart';
import '../theme/brand_theme.dart';
import '../shop/blufru/shop_list_page_blufru.dart';

class BrandHomeBlufru extends StatelessWidget {
  const BrandHomeBlufru({super.key});

  @override
  Widget build(BuildContext context) {
  const brand = 'blufru';
    final color = BrandTheme.colorFor(brand);

    return Scaffold(
      appBar: AppBar(title: const Text('blüfrü · Startseite')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.local_florist_outlined, size: 86, color: Colors.black54),
            const SizedBox(height: 18),
            Text('🌸 blüfrü – Vielfalt, Heilpflanzen & alte Sorten',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Text(
              'Blüfrü steht für die lebendige Kraft der Pflanzen.\nWir konzentrieren uns auf Kräuter und Heilpflanzen – für Küche, Wohlbefinden und naturnahe Gärten. Ergänzend bieten wir sorgfältig ausgewählte Demeter-Gemüse-Jungpflanzen an, die Vielfalt, Geschmack und Robustheit in Beete, Kübel und Balkone bringen.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
            const SizedBox(height: 12),
            Text(
              'Unsere Jungpflanzen stammen von Partnerbetrieben, von denen einer Demeter-zertifiziert ist, während die anderen nach unseren eigenen blüfrü-Mindeststandards wirtschaften – ökologisch, fair und im Einklang mit der Natur. Entscheidend ist für uns das gelebte Prinzip: gesunde Böden, respektvoller Umgang mit Wasser, Saatgut und Menschen. So entstehen Pflanzen, die in lebendiger Erde wachsen und echte Qualität in sich tragen.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
            const SizedBox(height: 12),
            Text(
              'Aktuell ziehen wir noch nicht selbst vor. Unsere Jungpflanzen erhalten wir exklusiv von diesen Partnern, die unsere Werte teilen und konsequent nach Demeter- oder blüfrü-Standards arbeiten. Das sichert konstante Qualität, nachvollziehbare Herkunft und kurze Wege. Blüfrü verbindet traditionelles Heilpflanzenwissen, alte Sorten und moderne Nachhaltigkeit – ehrlich, handwerklich und alltagsnah anwendbar.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
            const SizedBox(height: 12),
            Text(
              'Für alle, die Natur nicht nur sehen, sondern leben wollen – im Garten, auf der Terrasse oder am Küchenfenster. 👉 Blüfrü – weil Vielfalt wichtig ist.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopListPageBlufru()));
                },
                child: const Text('Mehr erfahren'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
