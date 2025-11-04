
import 'package:flutter/material.dart';

String formatPrice(dynamic price, String unit) {
  if (price == null) return 'Preis n/a';
  try {
    final p = (price is num) ? price.toDouble() : double.parse(price.toString());
    return '${p.toStringAsFixed(2)} € / $unit';
  } catch (_) {
    return 'Preis n/a';
  }
}

String? extractImage(Map<String, dynamic> m) {
  final keys = ['image','image_url','bild_url','img','picture'];
  for (final k in keys) {
    if (m.containsKey(k) && m[k] != null && m[k].toString().trim().isNotEmpty) {
      return m[k].toString().trim();
    }
  }
  return null;
}

String unitOf(Map<String, dynamic> m) {
  final raw = (m['unit'] ?? '').toString().toLowerCase();
  if (raw.isNotEmpty) {
    if (_isStk(raw)) return 'stk';
    if (_isLiter(raw)) return 'l';
    return 'kg';
  }
  final cname = (m['category_name'] ?? '').toString().toLowerCase();
  final name = (m['name'] ?? '').toString().toLowerCase();
  if (_looksLiquid(cname) || _looksLiquid(name)) return 'l';
  final cid = (m['category_id'] ?? '').toString().toUpperCase();
  if (cid == 'CAT04') return 'stk';
  return 'kg';
}

bool _isStk(String u) => u == 'stk' || u == 'stueck' || u == 'stück';
bool _isLiter(String u) => u == 'l' || u == 'liter';
bool _looksLiquid(String s) {
  const hints = ['öl','sirup','saft','milch','getränk','drink','essig','kombucha','limonade'];
  return hints.any((h) => s.contains(h));
}

String nameOf(Map<String, dynamic> m) => (m['name'] ?? 'Unbenannt').toString();
String idOf(Map<String, dynamic> m) => (m['id'] ?? '').toString();

double? priceOf(Map<String, dynamic> m) {
  final v = m['price'];
  if (v == null) return null;
  if (v is num) return v.toDouble();
  try { return double.parse(v.toString()); } catch (_) { return null; }
}

Color unitColor(String unit) {
  switch (unit) {
    case 'stk': return Colors.teal;
    case 'l': return Colors.blueGrey;
    default: return Colors.orange;
  }
}
