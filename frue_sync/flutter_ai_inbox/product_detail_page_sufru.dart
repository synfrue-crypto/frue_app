// This is a snapshot copy for review/patch purposes only.
// Analyzer warnings in this folder are ignored on purpose.
// ignore_for_file: uri_does_not_exist, undefined_identifier, undefined_method, unused_import

import 'package:flutter/material.dart';
import '../../theme/brand_theme.dart';
import '../../widgets/quantity_input.dart';
import '../../widgets/smart_image.dart';
import '../../cart/cart_provider.dart';

/// SÜFRÜ product detail tweaks:
/// - Consolidate long_desc, Anwendung, Composition into a single block under the title
/// - Show bio/demeter badge near title if present
/// - Add "Freimenge" input which is added to the ordered quantity (must be positive)

class ProductDetailPageSufru extends StatefulWidget {
  final String brand;
  final Map<String, dynamic> product;

  const ProductDetailPageSufru({super.key, required this.brand, required this.product});

  @override
  State<ProductDetailPageSufru> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPageSufru> {
  double qty = 1.0;
  double _freemenge = 0.0;
  final _freeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final brand = widget.brand;
    final color = BrandTheme.colorFor(brand);
    final priceStyle = BrandTheme.priceStyle(brand);

    final m = widget.product;
    final id = (m['id'] ?? '').toString();
    final name = (m['name'] ?? '').toString();
    final imgId = (m['asset_id'] ?? '').toString();
    final price = (m['price'] ?? 0).toDouble();
    final unit = (m['unit'] ?? '').toString();
    final shortDesc = (m['short_desc'] ?? '').toString();
    final longDesc = (m['long_desc'] ?? '').toString();
    // Step precedence: product qty_step, but special-case CAT04 or specific SKUs
    final rawStep = (m['qty_step'] ?? 1.0);
    double step = (rawStep is num) ? rawStep.toDouble() : double.tryParse(rawStep.toString()) ?? 1.0;
    final cat = (m['category_id'] ?? '').toString().toUpperCase();
    final pid = (m['id'] ?? '').toString();
    if (cat == 'CAT04' || pid == 'SFRU-012' || pid == 'SFRU-015') step = 0.25;

    return Scaffold(
      appBar: AppBar(title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 1.6,
            child: SmartAssetImage([imgId], fit: BoxFit.cover, borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(height: 12),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if ((m['brand_quality'] ?? '').toString().isNotEmpty) ...[
                  Image.asset('assets/icons/${m['brand_quality']}.png', height: 28, width: 28, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                  const SizedBox(width: 8),
                ],
                Text(name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              '${price.toStringAsFixed(2)} € / $unit',
              style: priceStyle,
            ),
          ),
          const SizedBox(height: 10),
          // Consolidated info block (long_desc, Anwendung, Composition)
          if (longDesc.isNotEmpty || (m['Anwendung'] ?? '').toString().isNotEmpty || (m['Composition'] ?? '').toString().isNotEmpty) ...[
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (longDesc.isNotEmpty) ...[
                      const Text('Beschreibung', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(longDesc),
                      const SizedBox(height: 10),
                    ],
                    if ((m['Anwendung'] ?? '').toString().isNotEmpty) ...[
                      const Text('Anwendung', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text((m['Anwendung'] ?? '').toString()),
                      const SizedBox(height: 10),
                    ],
                    if ((m['Composition'] ?? '').toString().isNotEmpty) ...[
                      const Text('Zusammensetzung', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text((m['Composition'] ?? '').toString()),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              QuantityInput(
                value: qty,
                onChanged: (v) => setState(() => qty = v),
                step: step,
                unitLabel: unit.isEmpty ? null : unit,
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _freeController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Freimenge', isDense: true),
                  onChanged: (v) {
                    final val = double.tryParse(v.replaceAll(',', '.')) ?? 0.0;
                    setState(() => _freemenge = val < 0 ? 0.0 : val);
                  },
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: color),
                onPressed: () {
                  final total = qty + (_freemenge.isNaN ? 0.0 : _freemenge);
                  CartProvider.of(context).add(id, by: total);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Zum Warenkorb hinzugefügt')),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Jetzt bestellen'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (shortDesc.isNotEmpty) Text(shortDesc),
          if (longDesc.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(longDesc),
          ],
        ],
      ),
    );
  }
}
