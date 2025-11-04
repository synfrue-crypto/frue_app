
import 'package:flutter/material.dart';

/// Quality badge for Bio/Demeter (icon-only).
/// Default size is 28px (Variante A).
class QualityBadges extends StatelessWidget {
  final String? brandQuality;
  final double size;
  const QualityBadges({super.key, this.brandQuality, this.size = 28});

  @override
  Widget build(BuildContext context) {
    final q = (brandQuality ?? '').toLowerCase().trim();
      String? asset;
      // Accept loose variants such as "Demeter, Bio", "bio/demeter", etc.
      if (q.contains('demeter')) {
        asset = 'assets/icons/demeter.png';
      } else if (q.contains('bio')) {
        asset = 'assets/icons/bio.png';
      }
    if (asset == null) return const SizedBox.shrink();

    // Avoid double 'assets/assets/...' on web by stripping a leading
    // 'assets/' segment before passing to Image.asset (the engine will
    // prefix the served URL with 'assets/').
    String display = asset;
    if (display.startsWith('assets/')) display = display.substring('assets/'.length);
    return Image.asset(display, height: size, width: size, fit: BoxFit.contain);
  }
}
