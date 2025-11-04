
// lib/widgets/asset_router.dart
import 'dart:convert';
import 'package:flutter/widgets.dart';

/// Resolves asset paths for product images and fixes common path issues
/// (e.g., duplicated "assets/assets/...", mixed separators, missing extension).
///
/// Usage:
///   await AssetRouter.ensureLoaded(context);
///   final path = AssetRouter.resolve('SFRU-001-A0001'); // or a full/partial path
///   Image.asset(path);
class AssetRouter {
  static final Set<String> _assets = <String>{};
  static bool _loaded = false;

  /// Load the AssetManifest once (needed on Web to know which files actually exist).
  static Future<void> ensureLoaded(BuildContext context) async {
    if (_loaded) return;
    // Use DefaultAssetBundle to read the manifest so tests/providers can override it.
    final manifestJson =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = json.decode(manifestJson);
    _assets
      ..clear()
      ..addAll(manifest.keys.map(_normalize));
    _loaded = true;
  }

  /// Public resolver. Accepts an ID like "SFRU-001-A0001" **or** any
  /// partial/garbled path and returns a clean, existing asset path.
  static String resolve(String? input) {
    // Preferred image homes. Older data lives under `assets/frue/images/`
    // while newer layout uses `assets/data/frue/images/`. Try both so
    // resolution works regardless of which one is present in the repo.
    const bases = [
      'assets/data/frue/images/',
      'assets/frue/images/',
    ];
    const placeholderPng = 'assets/frue/images/placeholder.png';
    const placeholderJpg = 'assets/frue/images/placeholder.jpg';
    const placeholderJpeg = 'assets/frue/images/placeholder.jpeg';

    // Small helper to pick the first that exists in the manifest
    String pickFirst(List<String> candidates) {
      for (final c in candidates.map(_normalize)) {
        if (_assets.contains(c)) return c;
      }
      // fallback order: prefer any existing placeholder in repo
      for (final c in [placeholderPng, placeholderJpg, placeholderJpeg]) {
        final n = _normalize(c);
        if (_assets.contains(n)) return n;
      }
      // Last resort: return the JPG placeholder under the most common folder
      return _normalize(placeholderJpg);
    }

    if (input == null || input.trim().isEmpty) {
      return pickFirst(const [placeholderPng, placeholderJpg, placeholderJpeg]);
    }

    final raw = _normalize(input);

    // If caller already passed a path that exists, use it.
    if (_assets.contains(raw)) return raw;

    // Heuristics:
    // 1) If it looks like a filename with an extension, try swapping jpg/png/jpeg.
    final hasSlash = raw.contains('/');

    if (hasSlash) {
      final withoutExt = raw.replaceAll(RegExp(r'\.(png|jpg|jpeg)$', caseSensitive: false), '');
      return pickFirst([
        '$withoutExt.png',
        '$withoutExt.jpg',
        '$withoutExt.jpeg',
      ]);
    }

    // 2) It is likely just an ID like "SFRU-001-A0001" → search under known bases.
    final id = raw;
    final List<String> idCandidates = [];
    for (final b in bases) {
      idCandidates.addAll([
        '$b$id.png',
        '$b$id.jpg',
        '$b$id.jpeg',
      ]);
    }
    return pickFirst(idCandidates);
  }

  /// Normalizes weird/duplicated segments like:
  /// - assets/assets/... → assets/...
  /// - assets/frue/images/data/frue/images/... → assets/data/frue/images/...
  /// - assets/assets/data/... → assets/data/...
  /// and forces forward slashes.
  static String _normalize(String p) {
    var s = p.replaceAll('\\', '/').trim();

    // Remove leading "./"
    if (s.startsWith('./')) s = s.substring(2);

    // Collapse duplicated "assets/" prefixes (e.g., assets/assets/..)
    s = s.replaceAll(RegExp(r'(^|/)assets\/assets\/'), r'\1assets/');

    // Fix common swapped segments like ".../frue/images/data/frue/images/"
    s = s.replaceAll(RegExp(r'frue/images/data/frue/images/'), 'data/frue/images/');
    s = s.replaceAll(RegExp(r'assets\/frue\/images\/data\/frue\/images\/'), 'assets/data/frue/images/');
    s = s.replaceAll(RegExp(r'assets\/data\/frue\/images\/data\/frue\/images\/'), 'assets/data/frue/images/');

    // If it already starts with assets/, keep it. If it starts with data/..., prefix assets/
    if (!s.startsWith('assets/')) {
      if (s.startsWith('data/')) s = 'assets/$s';
    }

    // Final collapse safeguard
    s = s.replaceAll('assets/assets/', 'assets/');

    return s;
  }
}
