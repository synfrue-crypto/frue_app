// lib/shop/grufru/shop_list_page_grufru.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../theme/brand_theme.dart';
import '../../widgets/product_card.dart';
import 'product_detail_page_grufru.dart';

class ShopListPageGrufru extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final String brand;

  const ShopListPageGrufru({
    super.key,
    required this.brand,
    required this.products,
  });

  @override
  State<ShopListPageGrufru> createState() => _ShopListPageGrufruState();
}

class _ShopListPageGrufruState extends State<ShopListPageGrufru> {
  late List<Map<String, dynamic>> _items;
  String? _activeCategory; // 'CAT01' etc.
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _items = List<Map<String, dynamic>>.from(widget.products);
    if (_items.isEmpty) {
      _loadLocalCatalog(); // Fallback: aus Assets laden
    }
  }

  Future<void> _loadLocalCatalog() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // erwartet: assets/data/catalog_grufru.json
      const path = 'assets/data/catalog_grufru.json';
      final raw = await rootBundle.loadString(path);
      final data = json.decode(raw);
      if (data is List) {
        _items = data
            .whereType<Map>()
            .map<Map<String, dynamic>>((m) => m.map(
                  (k, v) => MapEntry(k.toString(), v),
                ))
            .toList();
      } else {
        _error = 'Ungültiges Katalogformat in $path';
      }
    } catch (e) {
      _error = 'Katalog konnte nicht geladen werden: $e';
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final list = _items;
    if (_activeCategory == null) return list;
    return list
        .where((m) => (m['category_id'] ?? '').toString() == _activeCategory)
        .toList();
  }

  List<String> get _categories {
    final set = <String>{};
    for (final m in _items) {
      final c = (m['category_id'] ?? '').toString();
      if (c.isNotEmpty) {
        set.add(c);
      }
    }
    final list = set.toList()..sort();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final brand = widget.brand;
    final color = BrandTheme.colorFor(brand);

    return Scaffold(
      appBar: AppBar(
        title: Text('grüfrü · Shop', style: TextStyle(color: color)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Column(
                  children: [
                    // Category chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('Alle'),
                            selected: _activeCategory == null,
                            onSelected: (_) => setState(() => _activeCategory = null),
                          ),
                          const SizedBox(width: 8),
                          for (final c in _categories) ...[
                            FilterChip(
                              label: Text(c),
                              selected: _activeCategory == c,
                              onSelected: (_) => setState(() {
                                _activeCategory = c;
                              }),
                            ),
                            const SizedBox(width: 8),
                          ]
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Grid
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // simple responsive columns
                          final w = constraints.maxWidth;
                          int cols = 2;
                          if (w >= 1200) {
                            cols = 5;
                          } else if (w >= 992) {
                            cols = 4;
                          } else if (w >= 768) {
                            cols = 3;
                          }

                          final data = _filtered;
                          if (data.isEmpty) {
                            return const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.shopping_bag_outlined, size: 40),
                                  SizedBox(height: 8),
                                  Text('Keine Produkte gefunden'),
                                ],
                              ),
                            );
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: cols,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.78,
                            ),
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              final m = data[i];
                              return ProductCard(
                                product: m,
                                brand: brand,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailPageGrufru(
                                        brand: brand,
                                        product: m,
                                      ),
                                    ),
                                  );
                                },
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
}
