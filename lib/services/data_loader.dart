import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DataLoader {
  static Future<List<Map<String, dynamic>>> _loadJsonList(String path) async {
    final raw = await rootBundle.loadString(path);
    final data = json.decode(raw);
    if (data is List) {
      return data.cast<Map>().map((e) => e.map((k, v) => MapEntry(k.toString(), v))).toList().cast<Map<String, dynamic>>();
    }
    if (data is Map && data['items'] is List) {
      final list = (data['items'] as List).cast<Map>();
      return list.map((e) => e.map((k, v) => MapEntry(k.toString(), v))).toList().cast<Map<String, dynamic>>();
    }
    return <Map<String, dynamic>>[];
  }

  static Future<List<Map<String, dynamic>>> loadCatalogSufru() =>
      _loadJsonList('assets/data/catalog_sufru.json');

  static Future<List<Map<String, dynamic>>> loadCategories() =>
      _loadJsonList('assets/data/categories.json');

  static Future<List<Map<String, dynamic>>> loadFulfillment() =>
      _loadJsonList('assets/data/fulfillment.json');

  static Future<List<Map<String, dynamic>>> loadUnitsOverride() =>
      _loadJsonList('assets/data/units_override.json');
}
