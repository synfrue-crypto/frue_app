// lib/shop/grufru/product_detail_page_grufru.dart
import 'package:flutter/material.dart';

import '../../theme/brand_theme.dart';
import '../../widgets/smart_image.dart';

class ProductDetailPageGrufru extends StatefulWidget {
  const ProductDetailPageGrufru({
    super.key,
    required this.brand,
    required this.product,
  });

  final String brand; // 'grufru'
  final Map<String, dynamic> product;

  @override
  State<ProductDetailPageGrufru> createState() => _ProductDetailPageGrufruState();
}

class _ProductDetailPageGrufruState extends State<ProductDetailPageGrufru> {
  int _selectedVolume = 1; // in L (1,5,10)
  @override
  Widget build(BuildContext context) {
    final brand = widget.brand;
    final m = widget.product;

    final color = BrandTheme.colorFor(brand);
    final priceStyle = BrandTheme.priceStyle(brand);

    final name = (m['name'] ?? '').toString();
  final priceRaw = (m['price'] ?? 0);
  final price = double.tryParse(priceRaw.toString()) ?? 0.0;
    

    final imgIdRaw = (m['asset_id'] ?? '').toString().trim();
    final imgId = imgIdRaw.isEmpty ? null : imgIdRaw;

    final longDesc = (m['long_desc'] ?? m['description'] ?? '').toString();
    final application = (m['Anwendung'] ?? '').toString();
    final composition = (m['Composition'] ?? '').toString();
    final lab = (m['Laborwerte'] ?? '').toString();
    final origin = (m['Herkunft'] ?? '').toString();
    final notes = (m['Notizen'] ?? '').toString();
    final tags = (m['tags'] ?? '').toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Produkt')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bild
                    Expanded(
                      flex: 5,
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: SmartAssetImage([
                            imgId,
                          ],
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Preis
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // If volumes apply (L), allow quick selector and show total + base price
                          Row(
                            children: [
                              DropdownButton<int>(
                                value: _selectedVolume,
                                items: const [1, 5, 10].map((v) => DropdownMenuItem(value: v, child: Text('${v}L'))).toList(),
                                onChanged: (v) => setState(() => _selectedVolume = v ?? 1),
                              ),
                              const SizedBox(width: 12),
                              Text('${(price * _selectedVolume).toStringAsFixed(2)} €', style: priceStyle),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('Grundpreis: ${price.toStringAsFixed(2)} €/L', style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              // TODO: Warenkorb/Bestellen
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Zum Warenkorb hinzugefügt')),
                              );
                            },
                            child: const Text('Jetzt bestellen'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _section('Beschreibung', longDesc),
                if (application.isNotEmpty) _section('Anwendung', application),
                if (composition.isNotEmpty) _section('Zusammensetzung', composition),
                if (lab.isNotEmpty) _section('Laboranalyse', lab),
                if (origin.isNotEmpty) _section('Herkunft', origin),
                if (notes.isNotEmpty) _section('Notizen', notes),
                if (tags.isNotEmpty) _section('Transparenz', tags),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 4),
          Text(body),
        ],
      ),
    );
  }
}
