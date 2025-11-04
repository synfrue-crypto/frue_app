// blufru placeholder page (kept as simple Baustelle page to avoid analyzer errors)
import 'package:flutter/material.dart';

class ShopListPageBlufru extends StatelessWidget {
  const ShopListPageBlufru({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('blüfrü')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.construction, size: 64),
            SizedBox(height: 12),
            Text('Im Aufbau – bald verfügbar', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
