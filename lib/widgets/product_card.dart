import 'package:flutter/material.dart';
// theme not needed in simplified product card (grid)
import 'smart_image.dart';
import 'badges.dart';

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
  final imgId = (product['asset_id'] ?? '').toString();
  final name = (product['name'] ?? '').toString();
  final price = (product['price'] ?? 0).toDouble();
  final unit = (product['unit'] ?? 'kg').toString();

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
                  // small badge overlay in bottom-left of the image (like mock)
                  if ((product['brand_quality'] ?? '').toString().isNotEmpty)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(230),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: QualityBadges(brandQuality: (product['brand_quality'] ?? '').toString(), size: 20),
                      ),
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
                  // Title row: centered name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              // If product has a Demeter badge, tint the name green to match mock; otherwise keep default
                              color: (product['brand_quality'] ?? '').toString().toLowerCase().contains('demeter') ? const Color(0xFF2E7D32) : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  // Price label under title (small orange outlined box)
                  if (price > 0)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFFF9800)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${price.toStringAsFixed(2)} € / $unit',
                            style: const TextStyle(color: Color(0xFFFF9800), fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
