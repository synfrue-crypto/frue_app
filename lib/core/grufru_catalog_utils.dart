// flutter/material import removed (unused in this utility)

/// Kategorie-Check: Nur CAT01 (Flüssigdünger) hat Größenstufen (1/5/10 L) & Dropdown
bool isCat01(Map<String, dynamic> m) =>
    (m['category_id']?.toString().trim().toUpperCase() ?? '') == 'CAT01';

/// Extrahiert Tiers (z. B. {"1": 6.9, "5": 19.9, "10": 29.9}) aus möglichen Feldern.
/// Robust gegen verschiedene Schreibweisen und Zahlenformate.
Map<String, double> extractTierPrices(Map<String, dynamic> m) {
  final Map<String, double> out = {};

  double? asDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    final s = v.toString().trim().replaceAll(',', '.');
    return double.tryParse(s);
  }

  String? onlyNumber(String s) {
    final match = RegExp(r'(\d+(?:[.,]\d+)?)').firstMatch(s);
    if (match == null) return null;
    return match.group(1)!.replaceAll(',', '.');
  }

  // 1) Bekannte „Map“-Felder
  for (final key in ['price_tiers', 'prices', 'preise']) {
    final raw = m[key];
    if (raw is Map) {
      raw.forEach((k, v) {
        final sizeKey = onlyNumber(k.toString());
        final dv = asDouble(v);
        if (sizeKey != null && dv != null) {
          out[sizeKey] = dv;
        }
      });
    }
  }

  // 2) Flache Felder wie price_1, price_5, price_10
  for (final k in m.keys) {
    final mk = k.toString().toLowerCase();
    if (mk.startsWith('price_')) {
      final sizeKey = onlyNumber(mk.replaceFirst('price_', ''));
      final dv = asDouble(m[k]);
      if (sizeKey != null && dv != null) out[sizeKey] = dv;
    }
  }

  // 3) Fallback: Einzelpreis + Gebindegröße
  if (out.isEmpty) {
    final p = asDouble(m['price']);
    final sizeFromField = onlyNumber((m['Gebindegröße'] ?? m['size'] ?? '').toString());
    if (p != null && sizeFromField != null) out[sizeFromField] = p;
  }

  return out;
}

/// Liefert die kleinstmögliche Grundpreis-Angabe (ab €/L) für CAT01.
/// Für Nicht-CAT01: null (kein „ab“-Badge).
double? computeAbGrundpreisPerUnit(Map<String, dynamic> m, {String unit = 'l'}) {
  if (!isCat01(m)) return null;
  final tiers = extractTierPrices(m);
  if (tiers.isEmpty) return null;

  double? asDouble(String s) => double.tryParse(s.replaceAll(',', '.'));
  double best = double.infinity;

  tiers.forEach((sizeStr, price) {
    final s = asDouble(sizeStr);
    if (s != null && s > 0) {
      final gp = price / s; // €/L
      if (gp < best) best = gp;
    }
  });

  return best.isFinite ? best : null;
}

/// Prüft und meldet Inkonsistenzen, die beim Erzeugen aus Excel/Drive vorkommen können.
List<String> validateGrufruProduct(Map<String, dynamic> m) {
  final issues = <String>[];

  final id = m['id']?.toString() ?? '(ohne id)';
  final catId = m['category_id']?.toString() ?? '';
  final unit = m['unit']?.toString().toLowerCase() ?? '';

  if (id.isEmpty) issues.add('[$id] id fehlt/leer.');
  if (catId.isEmpty) issues.add('[$id] category_id fehlt.');
  if (unit.isEmpty) issues.add('[$id] unit fehlt (z. B. "l").');

  if (isCat01(m)) {
    final tiers = extractTierPrices(m);
    if (tiers.isEmpty) {
      issues.add('[$id] CAT01 ohne Tiers: erwarte z. B. 1/5/10 L mit Preisen.');
    }
    final gp = computeAbGrundpreisPerUnit(m) ;
    if (gp == null) {
      issues.add('[$id] Grundpreis (€/L) konnte nicht berechnet werden.');
    }
  }

  // Inhalte/Blöcke
  if ((m['long_desc']?.toString().trim().isEmpty ?? true) &&
      (m['Beschreibung']?.toString().trim().isEmpty ?? true)) {
    issues.add('[$id] Beschreibung/long_desc fehlt.');
  }
  if ((m['Anwendung']?.toString().trim().isEmpty ?? true)) {
    issues.add('[$id] Anwendung fehlt.');
  }
  if ((m['Composition']?.toString().trim().isEmpty ?? true)) {
    issues.add('[$id] Zusammensetzung (Composition) fehlt.');
  }
  // Laborwerte nur bei grufru relevant – wenn vorgesehen:
  if ((m['Laborwerte']?.toString().trim().isEmpty ?? true)) {
    issues.add('[$id] Laborwerte leer (falls vorgesehen).');
  }

  return issues;
}

/// Format „€“ hübsch
String euro(double v) {
  final s = (v == v.truncateToDouble()) ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
  return '${s.replaceAll('.', ',')} €';
}
