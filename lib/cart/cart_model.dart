import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  final Map<String, double> _items = {}; // id -> qty

  Map<String, double> get items => Map.unmodifiable(_items);

  void add(String id, {double by = 1.0}) {
    _items.update(id, (v) => v + by, ifAbsent: () => by);
    notifyListeners();
  }

  void set(String id, double qty) {
    if (qty <= 0) {
      _items.remove(id);
    } else {
      _items[id] = qty;
    }
    notifyListeners();
  }

  void remove(String id) {
    _items.remove(id);
    notifyListeners();
  }

  double qtyOf(String id) => _items[id] ?? 0.0;

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool get isEmpty => _items.isEmpty;
}
