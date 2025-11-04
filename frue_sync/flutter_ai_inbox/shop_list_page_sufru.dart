// This is a snapshot copy for review/patch purposes only.
// Analyzer warnings in this folder are ignored on purpose.
// ignore_for_file: uri_does_not_exist, undefined_identifier, undefined_method, unused_import, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../theme/brand_theme.dart';
import '../../widgets/product_card.dart';
import '../../widgets/smart_image.dart';
import '../../services/data_loader.dart';
import '../../cart/cart_provider.dart';
import 'product_detail_page_sufru.dart';

class ShopListPageSufru extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  const ShopListPageSufru({super.key, required this.products});

  @override
  State<ShopListPageSufru> createState() => _ShopListPageSufruState();
}

class _ShopListPageSufruState extends State<ShopListPageSufru> {
  String brand = 'sufru';
  String? selectedCategory;
  late List<Map<String, dynamic>> _all;
  List<String> _cats = [];
  String _search = '';

  @override
  void initState() {
    super.initState();
    _all = widget.products.where((p) => (p['active'] ?? true) == true).toList();
    _cats = _deriveCategories(_all);
  }

  List<String> _deriveCategories(List<Map<String, dynamic>> list) {
    final s = <String>{};
    for (final m in list) {
      final name = (m['category_name'] ?? '').toString();
      if (name.isNotEmpty) s.add(name);
    }
    final out = s.toList()..sort();
    return out;
  }

  List<Map<String, dynamic>> get _filtered {
    var list = _all;
    if (selectedCategory != null) {
      list = list.where((m) => (m['category_name'] ?? '').toString() == selectedCategory).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((m) => (m['name'] ?? '').toString().toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
  final chipTheme = BrandTheme.chipThemeFor(context, brand);

    return Scaffold(
      appBar: AppBar(
        title: const Text('süfrü · Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => _openCart(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Suche nach Produktname',
                isDense: true,
              ),
              onChanged: (v) => setState(() => _search = v.trim()),
            ),
          ),
          // Filterchips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                Theme(
                  data: Theme.of(context).copyWith(chipTheme: chipTheme),
                  child: ChoiceChip(
                    label: const Text('Alle'),
                    selected: selectedCategory == null,
                    onSelected: (_) => setState(() => selectedCategory = null),
                  ),
                ),
                for (final c in _cats)
                  Theme(
                    data: Theme.of(context).copyWith(chipTheme: chipTheme),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: selectedCategory == c,
                      onSelected: (_) => setState(() => selectedCategory = c),
                    ),
                  ),
              ],
            ),
          ),

          // Grid
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final cross = w >= 1200 ? 5 : w >= 900 ? 4 : w >= 600 ? 3 : 2;
                final products = _filtered;

                if (products.isEmpty) {
                  return const Center(child: Text('Keine Produkte gefunden'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.80,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, i) {
                    final m = products[i];
                    return ProductCard(
                      product: m,
                      brand: brand,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPageSufru(brand: brand, product: m),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCart(BuildContext context) async {
    final cart = CartProvider.of(context);
    // Simple Preview (ohne Checkout-Backend)
    final items = cart.items.entries.toList();
    final products = await DataLoader.loadCatalogSufru();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: items.isEmpty
                ? const Text('Warenkorb ist leer.')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Warenkorb', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (c, i) {
                            final e = items[i];
                            final prod = products.firstWhere(
                              (p) => (p['id'] ?? '') == e.key,
                              orElse: () => {'name': e.key, 'unit': ''},
                            );
                            return ListTile(
                              title: Text((prod['name'] ?? e.key).toString()),
                              subtitle: Text('Menge: ${e.value} ${(prod['unit'] ?? '').toString()}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  cart.remove(e.key);
                                  Navigator.pop(context);
                                  _openCart(context);
                                },
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(),
                          itemCount: items.length,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => cart.clear(),
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Leeren'),
                          ),
                          const Spacer(),
                          FilledButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.check),
                            label: const Text('Weiter'),
                          ),
                        ],
                      )
                    ],
                  ),
          ),
        );
      },
    );
  }
}
