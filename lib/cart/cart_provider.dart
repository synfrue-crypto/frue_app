import 'package:flutter/widgets.dart';
import 'cart_model.dart';

class CartProvider extends InheritedNotifier<CartModel> {
  final CartModel model;

  const CartProvider({super.key, required this.model, required Widget child})
      : super(notifier: model, child: child);

  static CartModel of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<CartProvider>();
    assert(w != null, 'CartProvider not found in tree');
    return w!.model;
    }
}
