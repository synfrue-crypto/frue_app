import 'package:flutter/material.dart';
import '../../theme/brand_theme.dart';
import '../../widgets/product_card.dart';
// '../../widgets/smart_image.dart' import removed — ProductCard handles images via SmartAssetImage
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
            onPressed: () => _openCart(),
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
        // Responsive grid per spec: XS 1 · SM 2 · MD 3 · LG 4+
        final cross = w >= 1200
          ? 4
          : w >= 900
            ? 3
            : w >= 600
              ? 2
              : 1;
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

  Future<void> _openCart() async {
    // Load catalog data first (avoid using an external BuildContext across the await)
    final products = await DataLoader.loadCatalogSufru();
    if (!mounted) return;

    // Show modal that reads cart items live from the provider so updates reflect immediately.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        final cartInSheet = CartProvider.of(sheetContext);
        final items = cartInSheet.items.entries.toList();

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

                            // Compute step and physical qty
                            final pStepRaw = prod['qty_step'] ?? 1.0;
                            final pStep = (pStepRaw is num) ? pStepRaw.toDouble() : double.tryParse(pStepRaw.toString()) ?? 1.0;
                            final units = e.value; // stored as units
                            final physQty = units * pStep;

                            return ListTile(
                              title: Text((prod['name'] ?? e.key).toString()),
                              subtitle: Text('Menge: ${physQty.toStringAsFixed(physQty.truncateToDouble()==physQty?0:2)} ${(prod['unit'] ?? '').toString()}'),
                              trailing: SizedBox(
                                width: 260,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: units > 0 ? () => cartInSheet.set(e.key, (units - 1) > 0 ? (units - 1) : 0) : null,
                                    ),
                                    SizedBox(
                                      width: 90,
                                      child: TextFormField(
                                        initialValue: physQty.toStringAsFixed(physQty.truncateToDouble()==physQty?0:2),
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        decoration: const InputDecoration(isDense: true, border: UnderlineInputBorder()),
                                        onFieldSubmitted: (v) {
                                          final val = double.tryParse(v.replaceAll(',', '.')) ?? physQty;
                                          final newUnits = (val / pStep);
                                          cartInSheet.set(e.key, newUnits <= 0 ? 0 : newUnits);
                                        },
                                      ),
                                    ),
                                    IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => cartInSheet.add(e.key, by: 1)),
                                    const SizedBox(width: 8),
                                    // line price
                                    Builder(builder: (ctx) {
                                      final price = (prod['price'] ?? 0).toDouble();
                                      final line = physQty * price;
                                      return Text('${line.toStringAsFixed(2)} €');
                                    }),
                                    const SizedBox(width: 8),
                                    IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => cartInSheet.remove(e.key)),
                                  ],
                                ),
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
                            onPressed: () => cartInSheet.clear(),
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
