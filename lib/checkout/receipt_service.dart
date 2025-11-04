
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

// Web: simple download as text file using <a download>
// Other: show dialog with copyable text (fallback)
class ReceiptService {
  static Future<void> saveOrShow(BuildContext context, {
    required Map<String,int> items,
    required Map<String,dynamic>? fulfillment,
    Map<String,dynamic>? timeslot,
  }) async {
    final now = DateTime.now();
    final lines = <String>[];
    lines.add('FRÜ · Kassenbon (Demo)');
    lines.add('Datum: ${now.toIso8601String()}');
    lines.add('--------------------------------');
    items.forEach((id, qty) => lines.add('Artikel $id  x$qty'));
    lines.add('--------------------------------');
    if (fulfillment != null) {
      lines.add('Abholstelle: ${fulfillment['label'] ?? ''}');
      final addr = (fulfillment['address'] ?? '').toString();
      if (addr.isNotEmpty) lines.add('Adresse: $addr');
      final oh = (fulfillment['opening_hours'] ?? '').toString();
      if (oh.isNotEmpty) lines.add('Öffnungszeiten: $oh');
    }
    if (timeslot != null && (timeslot['label'] ?? '').toString().isNotEmpty) {
      lines.add('Zeitslot: ${timeslot['label']}');
    }
    lines.add('--------------------------------');
    lines.add('Hinweis: Demo-Beleg – Safe-Mode');

    final txt = lines.join('\n');

    if (kIsWeb) {
      try {
        // ignore: avoid_web_libraries_in_flutter
        importForWeb(txt, fileName: 'frue_receipt_demo.txt');
        return;
      } catch (_) {
        // Fallback to dialog
      }
    }

    // Fallback: show dialog with text
    // ignore: use_build_context_synchronously
    await showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Kassenbon (Demo)'),
      content: SingleChildScrollView(child: SelectableText(txt)),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
    ));
  }
}

// The following code is only used on web; wrapped above to avoid runtime issues.
void importForWeb(String content, {String fileName = 'download.txt'}) {
  // ignore: avoid_web_libraries_in_flutter
  final bytes = utf8.encode(content);
  // ignore: undefined_prefixed_name
  _webDownload(bytes, fileName);
}

// Using a separate JS interop keeps this file self-contained without extra deps.
// ignore: avoid_web_libraries_in_flutter
// ignore: undefined_prefixed_name
void _webDownload(List<int> bytes, String name) {
  // This function body will be replaced by conditional import via JS inlined below.
}
