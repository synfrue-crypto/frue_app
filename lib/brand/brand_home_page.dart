import 'package:flutter/material.dart';
import 'brand_home_sufru.dart';
import '../shop/sufru/product_detail_page_sufru.dart';
import '../services/data_loader.dart';
import '../shop/sufru/shop_list_page_sufru.dart';
import 'brand_home_grufru.dart';
import 'brand_home_blufru.dart';
import 'shop_launcher.dart';

class BrandHomePage extends StatefulWidget {
  const BrandHomePage({super.key});

  @override
  State<BrandHomePage> createState() => _BrandHomePageState();
}

class _BrandHomePageState extends State<BrandHomePage> {
  bool _navigatedFromQuery = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // If the app is opened with a query parameter like `?open=sufru`, navigate directly to that brand page.
    if (!_navigatedFromQuery) {
      final param = Uri.base.queryParameters['open']?.toLowerCase();
  final detail = Uri.base.queryParameters['detail']?.toUpperCase();
  final gridParam = Uri.base.queryParameters['grid'];
      if (param != null && param.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // If detail is present and brand is sufru, attempt to open detail directly
          if (param == 'sufru' && detail != null && detail.isNotEmpty) {
            try {
              final products = await DataLoader.loadCatalogSufru();
              final prod = products.firstWhere((p) => (p['id'] ?? '').toString().toUpperCase() == detail, orElse: () => {});
              if (prod.isNotEmpty && mounted) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPageSufru(brand: 'sufru', product: prod)));
                return;
              }
            } catch (_) {
              // ignore and fall back to brand home
            }
          }
          // If grid param is present for sufru, open the shop grid directly
          if (param == 'sufru' && gridParam != null && gridParam.isNotEmpty) {
            try {
              final products = await DataLoader.loadCatalogSufru();
              if (mounted) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ShopListPageSufru(products: products)));
                return;
              }
            } catch (_) {
              // ignore
            }
          }
          _openBrand(param);
        });
        _navigatedFromQuery = true;
      }
    }
  }

  void _openBrand(String brand) {
    Widget page;
    switch (brand) {
      case 'sufru':
      case 'süfrü':
        page = const BrandHomeSufru();
        break;
      case 'grufru':
      case 'grüfrü':
        page = const BrandHomeGrufru();
        break;
      case 'blufru':
      case 'blüfrü':
        page = const BrandHomeBlufru();
        break;
      default:
        page = ShopLauncher(brand: brand);
    }
    if (mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('frü – Shops')),
      body: ListView(
        children: [
          _tile(context, 'süfrü – Früchte', 'sufru'),
          _tile(context, 'grüfrü – Garten', 'grufru'),
          _tile(context, 'blüfrü – Blumen', 'blufru'),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String title, String brand) {
    return ListTile(
      leading: CircleAvatar(child: Text(title.characters.first.toUpperCase())),
      title: Text(title),
      onTap: () {
        // Navigate to brand-specific startpage
        Widget page;
        switch (brand) {
          case 'sufru':
            page = const BrandHomeSufru();
            break;
          case 'grufru':
            page = const BrandHomeGrufru();
            break;
          case 'blufru':
            page = const BrandHomeBlufru();
            break;
          default:
            page = ShopLauncher(brand: brand);
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
