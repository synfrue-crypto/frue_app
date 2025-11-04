
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class OrderService {
  static String _endpoint = '';

  /// Einmalig beim App-Start aufrufen (nach AppConfig.init()).
  static Future<void> init() async {
    try {
      final raw = await rootBundle.loadString('config/.env');
      final env = _parseEnv(raw);
      _endpoint = (env['ORDER_ENDPOINT'] ?? '').trim();
    } catch (_) {
      _endpoint = '';
    }
  }

  static Map<String,String> _parseEnv(String s) {
    final out = <String,String>{};
    for (final line in const LineSplitter().convert(s)) {
      final t = line.trim();
      if (t.isEmpty || t.startsWith('#')) continue;
      final i = t.indexOf('=');
      if (i <= 0) continue;
      out[t.substring(0,i).trim()] = t.substring(i+1).trim();
    }
    return out;
  }

  /// Sendet die Vorbestellung an das Apps Script WebApp-Endpoint.
  static Future<bool> sendOrder({
    required String shop,
    required Map<String,int> items,
    required Map<String,dynamic> fulfillment,
    Map<String,dynamic>? timeslot,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? note,
  }) async {
    if (_endpoint.isEmpty) return false;
    final payload = {
      'shop': shop,
      'items': items,
      'fulfillment': fulfillment,
      'timeslot': timeslot,
      'customer': {
        'name': customerName ?? '',
        'email': customerEmail ?? '',
        'phone': customerPhone ?? '',
      },
      'note': note ?? '',
      'ts': DateTime.now().toIso8601String(),
      'app': 'frue_app',
      'version': 2
    };
    final resp = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );
    return resp.statusCode >= 200 && resp.statusCode < 300;
  }
}
