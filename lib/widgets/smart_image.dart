import 'package:flutter/material.dart';
import 'asset_router.dart';

/// SmartAssetImage now integrates with AssetRouter to resolve asset IDs or
/// paths to the canonical asset under `assets/data/frue/images/` and falls
/// back to the placeholder when nothing is found.
class SmartAssetImage extends StatelessWidget {
  final List<String?> candidates; // raw ids or paths
  final BoxFit fit;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const SmartAssetImage(
    this.candidates, {
    super.key,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure the asset manifest is loaded (no-op if already loaded).
    return FutureBuilder<void>(
      future: AssetRouter.ensureLoaded(context),
      builder: (context, snap) {
        // Resolve first candidate to an existing asset (AssetRouter.resolve
        // will return the placeholder when nothing matches).
  // Prefer mobile variants on narrow screens
  final bool preferMobile = MediaQuery.maybeOf(context)?.size.width != null && MediaQuery.of(context).size.width < 600;
  String resolved = AssetRouter.resolve(candidates.isNotEmpty ? (candidates.first ?? '') : '', preferMobile: preferMobile);

        // On web the engine may prefix the request path with `assets/`.
        // If the resolved path already starts with `assets/` we should strip
        // the leading segment before passing it to Image.asset to avoid
        // producing requests like `assets/assets/...`.
        String displayPath = resolved;
        if (displayPath.startsWith('assets/')) {
          displayPath = displayPath.substring('assets/'.length);
        }

        // If the first resolution is a placeholder and there are more
        // candidates, try others.
        if (resolved.contains('placeholder') && candidates.length > 1) {
          for (final c in candidates.skip(1)) {
            final tryRes = AssetRouter.resolve(c ?? '', preferMobile: preferMobile);
            if (!tryRes.contains('placeholder')) {
              resolved = tryRes;
              break;
            }
          }
        }

        Widget img = Image.asset(
          displayPath,
          fit: fit,
          height: height,
          width: width,
          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined, size: 32),
        );

        if (borderRadius != null) {
          return ClipRRect(borderRadius: borderRadius!, child: img);
        }
        return img;
      },
    );
  }
}
