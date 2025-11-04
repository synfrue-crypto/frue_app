import 'package:flutter/material.dart';
import 'app_config.dart';
import 'logger.dart';

class AppStatusOverlay extends StatefulWidget {
  final Widget child;
  const AppStatusOverlay({super.key, required this.child});

  @override
  State<AppStatusOverlay> createState() => _AppStatusOverlayState();
}

class _AppStatusOverlayState extends State<AppStatusOverlay> {
  String status = 'Init…';

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    Logger.info('App-Status geladen');
    status = AppConfig.drivePrep ? 'Drive-Prep aktiv' : 'Offline-Modus';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          bottom: 8,
          right: 8,
          child: Opacity(
            opacity: 0.8,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                status,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
