import 'package:flutter/material.dart';

// Direkter Sprung in die Shop-Seiten:
import 'package:frue_app/shop/sufru/shop_list_page_sufru.dart' as su;
import 'package:frue_app/shop/grufru/shop_list_page_grufru.dart' as gr;
import 'package:frue_app/shop/blufru/shop_list_page_blufru.dart' as bl;

class FrueApp extends StatelessWidget {
  const FrueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'frü',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const _HomeGate(),
    );
  }
}

class _HomeGate extends StatelessWidget {
  const _HomeGate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('frü · Start')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tile(
            context,
            'süfrü',
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const su.ShopListPageSufru(
                  // süfrü-Seite erwartet products (nicht-nullbar)
                  products: <Map<String, dynamic>>[],
                ),
              ),
            ),
          ),
          _tile(
            context,
            'grüfrü',
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const gr.ShopListPageGrufru(
                  brand: 'grufru',
                  products: <Map<String, dynamic>>[],
                ),
              ),
            ),
          ),
          _tile(
            context,
            'blüfrü (im Aufbau)',
            Colors.blueGrey,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const bl.ShopListPageBlufru(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
