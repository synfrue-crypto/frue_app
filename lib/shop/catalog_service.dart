
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CatalogService {
  CatalogService._();
  static final CatalogService instance = CatalogService._();
  List<dynamic>? _cache;

  Future<List<dynamic>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/catalog.json');
    final decoded = json.decode(raw);
    if (decoded is List) {
      _cache = decoded;
    } else if (decoded is Map) {
      for (final v in decoded.values) {
        if (v is List) { _cache = v; break; }
      }
      _cache ??= [];
    } else {
      _cache = [];
    }
    return _cache!;
  }
}
