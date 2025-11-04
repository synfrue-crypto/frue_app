// This is a snapshot copy for review/patch purposes only.
// Analyzer warnings in this folder are ignored on purpose.
// ignore_for_file: uri_does_not_exist, undefined_identifier, undefined_method, unused_import

import 'package:flutter/material.dart';
import '../theme/brand_theme.dart';
import 'smart_image.dart';
import 'badges.dart';
import '../cart/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final String brand;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.brand,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = BrandTheme.colorFor(brand);
    final priceStyle = BrandTheme.priceStyle(brand);

    final imgId = (product['asset_id'] ?? '').toString();
    final name = (product['name'] ?? '').toString();
    final price = (product['price'] ?? 0).toDouble();
    final unit = (product['unit'] ?? '').toString();
    final id = (product['id'] ?? '').toString();

    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 1.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SmartAssetImage([imgId], fit: BoxFit.cover),
                  // Badge (bio/demeter) in top-right if present
                  if ((product['brand_quality'] ?? '').toString().isNotEmpty)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: QualityBadges(brandQuality: (product['brand_quality'] ?? '').toString(), size: 36),
                    ),
                ],
              ),
            ),
            // Make the lower area flexible so long product names / price rows
            // don't overflow the card when the grid constraints are tight.
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                // Use minimal main axis size so the column only takes the
                // space it needs instead of stretching to the available
                // height. This prevents small overflows when grid cells are
                // tight.
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    // slightly reduced vertical padding to help avoid tiny
                    // overflows while keeping visual spacing
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 1),
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${price.toStringAsFixed(2)} €/ $unit', style: priceStyle),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(Icons.add_shopping_cart, color: color),
                          onPressed: () => CartProvider.of(context).add(id),
                          tooltip: 'In den Warenkorb',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
