
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' show rootBundle;

class DataLoader {
  /// Resilient loader: versucht mehrere Pfade/Fallbacks und loggt nachvollziehbar.
  static Future<List<dynamic>> loadCatalog(String brand) async {
    final candidates = <String>[
      'assets/data/catalog_${brand.toLowerCase()}.json',
      'assets/data/catalog.json',
      'assets/catalog_${brand.toLowerCase()}.json',
      'assets/catalog.json',
    ];
    final raw = await _tryLoadFirst(candidates);
    if (raw == null) {
      log('[DataLoader] Katalog nicht gefunden. Versucht: ${candidates.join(', ')}');
      return const [];
    }
    final fixed = _sanitizeJsonLiterals(raw);
    final decoded = json.decode(fixed);
    if (decoded is List) return decoded;
    if (decoded is Map && decoded['items'] is List) return decoded['items'];
    return const [];
  }

  static Future<List<Map<String,dynamic>>> loadFulfillment(String brand) async {
    final candidates = <String>[
      'assets/data/fulfillment_${brand.toLowerCase()}.json',
      'assets/data/fulfillment.json',
      'assets/fulfillment_${brand.toLowerCase()}.json',
      'assets/fulfillment.json',
    ];
    final raw = await _tryLoadFirst(candidates);
    if (raw == null) {
      log('[DataLoader] Fulfillment nicht gefunden. Versucht: ${candidates.join(', ')}');
      return const [];
    }
    final fixed = _sanitizeJsonLiterals(raw);
    final decoded = json.decode(fixed);
    final list = (decoded is List) ? decoded
               : (decoded is Map && decoded['items'] is List) ? decoded['items']
               : const [];
    return list.map<Map<String,dynamic>>((e) => _toStringKeyMap(e)).toList();
  }

  // ---- helpers ----
  static Future<String?> _tryLoadFirst(List<String> paths) async {
    for (final p in paths) {
      try {
  final s = await rootBundle.loadString(p);
  log('[DataLoader] geladen: $p');
        return s;
      } catch (_) { /* try next */ }
    }
    return null;
  }

  static Map<String,dynamic> _toStringKeyMap(dynamic e) {
    final m = <String,dynamic>{};
    if (e is Map) {
      e.forEach((k,v){ if (k is String) m[k]=v; });
    }
    return m;
  }

  static String _sanitizeJsonLiterals(String raw) {
    final re = RegExp(r':\s*(NaN|Infinity|-Infinity)\b');
    return raw.replaceAllMapped(re, (m) => ': null');
  }
}
