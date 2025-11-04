
import 'package:flutter/material.dart';
import 'app_config.dart';

class DriveStatusOverlay extends StatelessWidget {
  final Widget child;
  const DriveStatusOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final mode = AppConfig.safeMode ? 'SAFE' : 'LIVE';
    final prep = AppConfig.drivePrep ? 'DRIVE PREP' : 'OFFLINE';
    return Stack(
      children: [
        child,
        Positioned(
          right: 8, bottom: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black54, borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text('$mode · $prep',
                style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ),
      ],
    );
  }
}
