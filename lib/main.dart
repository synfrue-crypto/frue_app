import 'package:flutter/material.dart';
import 'brand/shop_launcher.dart';
import 'cart/cart_model.dart';
import 'cart/cart_provider.dart';

void main() {
  final cart = CartModel();
  runApp(CartProvider(model: cart, child: const FrueApp()));
}

class FrueApp extends StatelessWidget {
  const FrueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'frü · Shops',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
      home: const ShopLauncher(),
    );
  }
}
