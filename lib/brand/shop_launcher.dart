import 'package:flutter/material.dart';
// data_loader no longer needed here; BrandHome pages load catalogs when needed
import 'brand_home_sufru.dart';
// import '../shop/sufru/shop_list_page_sufru.dart'; // unused — BrandHome pages load catalogs themselves

class ShopLauncher extends StatelessWidget {
  final String? brand;
  const ShopLauncher({super.key, this.brand});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('frü · Shops')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.local_grocery_store),
            title: const Text('süfrü öffnen'),
            subtitle: const Text('Startseite → Grid → Detail → Warenkorb'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BrandHomeSufru(),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.eco_outlined),
            title: const Text('grüfrü'),
            subtitle: const Text('Im Aufbau – später aktivierbar'),
            trailing: const Icon(Icons.construction),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('grüfrü: später aktivierbar')),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.local_florist_outlined),
            title: const Text('blüfrü'),
            subtitle: const Text('Im Aufbau – später aktivierbar'),
            trailing: const Icon(Icons.construction),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('blüfrü: später aktivierbar')),
            ),
          ),
        ],
      ),
    );
  }
}
