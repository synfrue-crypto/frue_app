import 'package:flutter/material.dart';

class BrandTheme {
  static Color colorFor(String brand) {
    switch (brand.toLowerCase()) {
      case 'sufru':
      case 'süfrü':
        return const Color(0xFFFF9800); // Orange
      case 'grufru':
      case 'grüfrü':
        return const Color(0xFF2E7D32); // Grün
      case 'blufru':
      case 'blüfrü':
        return const Color(0xFF1976D2); // Blau
      default:
        return Colors.grey.shade800;
    }
  }

  static TextStyle priceStyle(String brand) =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colorFor(brand));

  static ChipThemeData chipThemeFor(BuildContext context, String brand) {
    final color = colorFor(brand);
    // Replace deprecated withOpacity(...) uses with withAlpha(...) to avoid analyzer deprecation warnings.
    // Alpha values: 0.15 -> 38, 0.35 -> 89, 0.25 -> 64 (0..255 scale)
    return ChipTheme.of(context).copyWith(
      selectedColor: color.withAlpha(38),
      backgroundColor: Colors.black12,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      secondaryLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      side: BorderSide(color: color.withAlpha(89)),
      shape: StadiumBorder(side: BorderSide(color: color.withAlpha(64))),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    );
  }
}
