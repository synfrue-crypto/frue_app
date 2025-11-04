import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo(this.brand, {super.key, this.size = 56});
  final String brand;
  final double size;

  String get _path {
    final b = brand.toLowerCase();
    if (b.contains('grufru')) return 'assets/brand/grufru_logo.png';
    if (b.contains('sufru'))  return 'assets/brand/sufru_logo.png';
    if (b.contains('blufru')) return 'assets/brand/blufru_logo.png';
    return 'assets/brand/grufru_logo.png'; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.18),
      child: Image.asset(
        _path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: size, height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(size * 0.18),
          ),
          child: const Icon(Icons.local_florist, size: 24, color: Colors.black38),
        ),
      ),
    );
  }
}
