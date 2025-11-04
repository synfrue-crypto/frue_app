
// 'foundation' import removed; 'widgets' provides ChangeNotifier and other types used here
import 'package:flutter/widgets.dart';

/// Warenkorb-Model (ChangeNotifier)
class CartModel extends ChangeNotifier {
  final Map<String, int> _items = {};
  Map<String, int> get items => Map.unmodifiable(_items);

  Map<String, dynamic>? _fulfillment; // ausgewählte Abholstelle
  Map<String, dynamic>? get fulfillment => _fulfillment;

  Map<String, dynamic>? _timeslot;
  Map<String, dynamic>? get timeslot => _timeslot;

  void setFulfillment(Map<String, dynamic>? station) {
    _fulfillment = station;
    _timeslot = null; // Slot zurücksetzen
    notifyListeners();
  }

  void setTimeslot(Map<String, dynamic>? slot) {
    _timeslot = slot;
    notifyListeners();
  }

  void add(String id, {int qty = 1}) {
    _items.update(id, (v) => v + qty, ifAbsent: () => qty);
    notifyListeners();
  }

  void remove(String id, {int qty = 1}) {
    if (!_items.containsKey(id)) return;
    final left = (_items[id]! - qty);
    if (left <= 0) {
      _items.remove(id);
    } else {
      _items[id] = left;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _fulfillment = null;
    _timeslot = null;
    notifyListeners();
  }

  int count() => _items.values.fold(0, (a,b) => a+b);
}

/// Minimaler Provider auf Basis von InheritedNotifier,
/// damit wir kein externes Provider-Package brauchen.
class CartProvider extends InheritedNotifier<CartModel> {
  const CartProvider({super.key, required CartModel model, required super.child})
      : super(notifier: model);

  static CartModel of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CartProvider>();
    assert(provider != null, 'CartProvider not found in widget tree.');
    return provider!.notifier!;
  }

  @override
  bool updateShouldNotify(covariant InheritedNotifier<CartModel> oldWidget) {
    return oldWidget.notifier != notifier;
  }
}
