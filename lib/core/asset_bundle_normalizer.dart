// lib/core/asset_bundle_normalizer.dart
import 'dart:async';
import 'package:flutter/services.dart';
// 'foundation' import removed (unnecessary); 'widgets' is required for widgets used below
import 'package:flutter/widgets.dart';

/// Normalisiert ALLE Asset-Keys global.
/// - Entfernt doppeltes "assets/assets/"
/// - Mapped "frue/images/" -> "data/frue/images/"
/// - Entfernt Dopplungen "data/frue/images/data/frue/images/"
/// - Erzwingt genau EIN führendes "assets/".
/// Zusätzlich: Probiert png/jpg/jpeg automatisch, wenn ein Key scheitert.
class NormalizingAssetBundle extends CachingAssetBundle {
  NormalizingAssetBundle(this._base);

  final AssetBundle _base;

  static String _normalizeOnce(String key) {
    var s = key.trim();

    // führendes "assets/" mehrfach → zu einem
    while (s.startsWith('assets/assets/')) {
      s = s.replaceFirst('assets/assets/', 'assets/');
    }

    // wenn ohne "assets/" übergeben → genau ein "assets/" vorn
    if (!s.startsWith('assets/')) {
      s = 'assets/$s';
    }

    // "frue/images/" → "data/frue/images/"
    s = s.replaceAll('assets/frue/images/', 'assets/data/frue/images/');

    // Doppelungen entfernen
    s = s.replaceAll('assets/data/frue/images/assets/data/frue/images/', 'assets/data/frue/images/');
    s = s.replaceAll('assets/assets/data/frue/images/', 'assets/data/frue/images/');

    // falls jemand ohne "assets/" drinnen herum-referenzierte:
    if (s.contains('data/frue/images/data/frue/images/')) {
      s = s.replaceAll('data/frue/images/data/frue/images/', 'data/frue/images/');
    }

    return s;
  }

  static String _ensureLogical(String key) {
    var s = key.trim();
    if (s.startsWith('assets/')) return s;
    return 'assets/$s';
  }

  static const List<String> _exts = ['.png', '.jpg', '.jpeg'];

  /// Prüft Kandidaten mit Endungen (falls keine/andere Endung übergeben wurde).
  Future<ByteData> _tryLoadWithExtFallback(String normalizedKey) async {
    // Wenn Key bereits eine bekannte Endung hat → zuerst genau so laden
    for (final e in _exts) {
      if (normalizedKey.toLowerCase().endsWith(e)) {
        return _base.load(normalizedKey);
      }
    }
    // Keine bekannte Endung → Endungen durchprobieren
    for (final e in _exts) {
      final k = normalizedKey + e;
      try {
        return await _base.load(k);
      } catch (_) {
        // weiterprobieren
      }
    }
    // Letzter Versuch: ohne Endung
    return _base.load(normalizedKey);
  }

  @override
  Future<ByteData> load(String key) async {
    // 1) Normalisieren
    final n1 = _normalizeOnce(key);
    try {
      return await _base.load(n1);
    } catch (_) {
      // 2) Endungen probieren
      try {
        return await _tryLoadWithExtFallback(n1);
      } catch (_) {
        // 3) Noch einmal „sanft“ normalisieren (falls jemand ohne assets/ aufruft)
        final n2 = _ensureLogical(key);
        if (n2 != n1) {
          try {
            return await _base.load(n2);
          } catch (_) {
            try {
              return await _tryLoadWithExtFallback(n2);
            } catch (_) {
              // Letzter Versuch: harte Dopplungen herausfiltern
              final n3 = _normalizeOnce(n2);
              if (n3 != n2) {
                return await _base.load(n3);
              }
              rethrow;
            }
          }
        }
        rethrow;
      }
    }
  }

  // Optional: Weiterleitungen für andere Methoden (Images benutzt i. d. R. load)
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final k = _normalizeOnce(key);
    return _base.loadString(k, cache: cache);
  }

  @override
  Future<T> loadStructuredData<T>(String key, Future<T> Function(String value) parser) {
    final k = _normalizeOnce(key);
    return _base.loadStructuredData<T>(k, parser);
  }

  @override
  void evict(String key) {
    final k = _normalizeOnce(key);
    _base.evict(k);
    super.evict(k);
  }
}

/// Einfacher Wrapper, den du um deine App legst:
class AssetBundleScope extends StatelessWidget {
  const AssetBundleScope({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // rootBundle ist der Default – wir hängen unseren Normalizer davor.
    return DefaultAssetBundle(
      bundle: NormalizingAssetBundle(rootBundle),
      child: child,
    );
  }
}
