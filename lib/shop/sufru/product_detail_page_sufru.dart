import 'package:flutter/material.dart';
import '../../theme/brand_theme.dart';
import '../../widgets/quantity_input.dart';
import '../../widgets/smart_image.dart';
import '../../widgets/badges.dart';
import '../../cart/cart_provider.dart';
import '../cart_page.dart';
import '../../services/data_loader.dart';

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
  final origin = (m['origin'] ?? '').toString();
  final usageField = (m['usage'] ?? m['Anwendung'] ?? '').toString();
  final composition = (m['Composition'] ?? m['composition'] ?? '').toString();
  final tagsField = (m['tags'] ?? '').toString();
    final taste = (m['taste'] ?? m['Geschmack'] ?? '').toString();
    final season = (m['season'] ?? m['Reife'] ?? m['Saison'] ?? '').toString();
    final allergens = (m['allergens'] ?? m['Allergene'] ?? '').toString();
    final storage = (m['storage'] ?? m['Lagerung'] ?? '').toString();
    final certificates = (m['certificates'] ?? m['Zertifikate'] ?? '').toString();

  // Slightly larger, friendlier typography for the sufru design language
  final headingStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 15) ?? const TextStyle(fontWeight: FontWeight.w700, fontSize: 15);
  final bodyStyle = Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5, fontSize: 15, color: Colors.black87) ?? const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87);

  // Only show the unified info block when at least one of the requested fields is present
  final hasInfo = longDesc.isNotEmpty || usageField.isNotEmpty || composition.isNotEmpty || origin.isNotEmpty || shortDesc.isNotEmpty || tagsField.isNotEmpty;
  // Step precedence: product qty_step, but special-case CAT04 or specific SKUs
  final rawStep = (m['qty_step'] ?? 1.0);
  double step = (rawStep is num) ? rawStep.toDouble() : double.tryParse(rawStep.toString()) ?? 1.0;
  final cat = (m['category_id'] ?? '').toString().toUpperCase();
  final pid = (m['id'] ?? '').toString();
  // Category CAT04 should use whole-number step increments (1,2,3,...)
  if (cat == 'CAT04') {
    step = 1.0;
  } else if (pid == 'SFRU-012' || pid == 'SFRU-015') {
    // legacy special SKUs keep smaller step
    step = 0.25;
  }

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
                  QualityBadges(brandQuality: (m['brand_quality'] ?? '').toString(), size: 28),
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
          // Unified info block (no Card) — show many optional product fields from catalog_sufru.json
          // Fields: Beschreibung(long_desc), Herkunft(origin), Geschmack(taste), Reife/Saison(season),
          // Allergene(allergens), Lagerung(storage), Anwendung(usage), Zertifikate(certificates), Transparenz/Tags(tags)
          // Present as a single flowing block: heading (slightly bold) then text — warm, friendly spacing.
          if (hasInfo) ...[
            const SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                            // Desired order per spec: Beschreibung → Herkunft → Geschmack → Reife / Saison → Allergene → Lagerung → Anwendung → Zertifikate → Transparenz
                            if (longDesc.isNotEmpty) ...[
                              Text('Beschreibung', style: headingStyle),
                              const SizedBox(height: 6),
                              Text(longDesc, style: bodyStyle),
                              const SizedBox(height: 10),
                            ],
                            if (origin.isNotEmpty) ...[
                              Text('Herkunft', style: headingStyle),
                              const SizedBox(height: 6),
                              Text(origin, style: bodyStyle),
                              const SizedBox(height: 10),
                            ],
                            if (taste.isNotEmpty) ...[
                              Text('Geschmack', style: headingStyle),
                              const SizedBox(height: 6),
                              Text(taste, style: bodyStyle),
                              const SizedBox(height: 10),
                            ],
                            if (season.isNotEmpty) ...[
                              Text('Reife / Saison', style: headingStyle),
                              const SizedBox(height: 6),
                              Text(season, style: bodyStyle),
                              const SizedBox(height: 10),
                            ],
                            if (allergens.isNotEmpty) ...[
                              Text('Allergene', style: headingStyle),
                              const SizedBox(height: 6),
                              Text(allergens, style: bodyStyle),
                              const SizedBox(height: 10),
                            ],
                            if (storage.isNotEmpty) ...[
                              Text('Lagerung', style: headingStyle),
                              const SizedBox(height: 6),
                              Text(storage, style: bodyStyle),
                              const SizedBox(height: 10),
                            ],
                            if (usageField.isNotEmpty) ...[
                              Text('Anwendung', style: headingStyle),
                              const SizedBox(height: 6),
                              Text(usageField, style: bodyStyle),
                              const SizedBox(height: 10),
                            ],
                            if (certificates.isNotEmpty) ...[
                              Text('Zertifikate', style: headingStyle),
                              const SizedBox(height: 6),
                              Text(certificates, style: bodyStyle),
                              const SizedBox(height: 10),
                            ],
                            if (tagsField.isNotEmpty) ...[
                              Text('Transparenz', style: headingStyle),
                              const SizedBox(height: 6),
                              Text(tagsField, style: bodyStyle),
                            ],
              ],
            ),
            const SizedBox(height: 12),
          ],
          // Menge + Freimenge row — match mock: stepper + displayed qty, and an inline freitext input with hint
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Menge:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              QuantityInput(
                value: qty,
                onChanged: (v) => setState(() => qty = v),
                step: step,
                unitLabel: unit.isEmpty ? null : unit,
              ),
              const SizedBox(width: 12),
              // inline freimenge field with subtle hint
              SizedBox(
                width: 160,
                child: TextField(
                  controller: _freeController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    hintText: 'oder Wunschmenge eintragen',
                    labelText: 'Freimenge',
                    isDense: true,
                    border: UnderlineInputBorder(),
                  ),
                  onChanged: (v) {
                    final val = double.tryParse(v.replaceAll(',', '.')) ?? 0.0;
                    setState(() => _freemenge = val < 0 ? 0.0 : val);
                  },
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: color),
                onPressed: () async {
                  final total = qty + (_freemenge.isNaN ? 0.0 : _freemenge);
                  if (total <= 0) return;
                  // Convert physical quantity into cart 'units' (units = total / step)
                  final units = (total / step);
                  CartProvider.of(context).add(id, by: units);

                  // Navigate to Cart (kein Popup). Try to provide product index for naming/prices.
                  final ctx = context; // capture BuildContext before await
                  final catalog = await DataLoader.loadCatalogSufru();
                  if (!ctx.mounted) return;
                  final index = <String, Map<String, dynamic>>{
                    for (final p in catalog) (p['id'] ?? '').toString(): p,
                  };
                  // Push CartPage with index
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => CartPage(productIndex: index),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('In den Warenkorb'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
