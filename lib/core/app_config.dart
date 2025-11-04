
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AppConfig {
  static bool safeMode = true;
  static bool drivePrep = true;

  static String driveCatalogId = '';
  static String driveUnitsId = '';
  static String driveFulfillmentId = '';

  static const localCategories = 'assets/data/categories.json';
  static const localUnits = 'assets/data/units_override.json';

  static String localCatalog(String brand) => 'assets/data/$brand/catalog.json';
  static String localFulfillment(String brand) => 'assets/data/$brand/fulfillment.json';

  static Future<void> init() async {
    try {
      final raw = await rootBundle.loadString('config/.env');
      final map = _parseEnv(raw);
      safeMode = _asBool(map['SAFE_MODE'], def: true);
      drivePrep = _asBool(map['DRIVE_PREP'], def: true);
      driveCatalogId = (map['DRIVE_CATALOG_ID'] ?? '').trim();
      driveUnitsId = (map['DRIVE_UNITS_ID'] ?? '').trim();
      driveFulfillmentId = (map['DRIVE_FULFILLMENT_ID'] ?? '').trim();
    } catch (_) {}
  }

  static Map<String,String> _parseEnv(String s) {
    final out = <String,String>{};
    for (final line in LineSplitter.split(s)) {
      final t = line.trim();
      if (t.isEmpty || t.startsWith('#')) continue;
      final i = t.indexOf('=');
      if (i <= 0) continue;
      out[t.substring(0,i).trim()] = t.substring(i+1).trim();
    }
    return out;
  }

  static bool _asBool(String? v, {required bool def}) {
    if (v == null) return def;
    final t = v.toLowerCase();
    return t == '1' || t == 'true' || t == 'yes' || t == 'on';
  }
}
