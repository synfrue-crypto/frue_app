
import 'package:flutter/material.dart';
import '../cart/cart_provider.dart';
// using CartProvider to access the model; no direct cart_model import required here
import 'product_utils.dart' show nameOf, unitOf, priceOf;
import 'fulfillment_selector.dart';

class CartPage extends StatelessWidget {
  final Map<String, Map<String, dynamic>>? productIndex;
  const CartPage({super.key, this.productIndex});

  Map<String, dynamic>? _lookup(String id) {
    if (productIndex == null) return null;
    return productIndex![id];
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    final ids = cart.items.keys.toList();

    double lineTotal(String id, double units) {
      final p = _lookup(id);
      final step = (p?['qty_step'] is num) ? (p!['qty_step'] as num).toDouble() : ((p != null && unitOf(p).toLowerCase() == 'kg') ? 0.5 : 1.0);
      final qty = units * step;
      final price = (p != null ? (priceOf(p) ?? 0).toDouble() : 0.0);
      return qty * price;
    }

  final total = ids.fold<double>(0.0, (sum, id) => sum + lineTotal(id, cart.items[id]!));

    return Scaffold(
      appBar: AppBar(title: const Text('Warenkorb')),
      body: ids.isEmpty
          ? const Center(child: Text('Dein Warenkorb ist leer.'))
          : ListView.separated(
              itemCount: ids.length + 1,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                if (i == ids.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text('Summe', style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        Text('${total.toStringAsFixed(2)} €', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  );
                }
                final id = ids[i];
                final units = cart.items[id]!;
                final p = _lookup(id);
                final name = p != null ? nameOf(p) : id;
                final unit = p != null ? unitOf(p) : 'stk';
                final step = (p?['qty_step'] is num) ? (p!['qty_step'] as num).toDouble() : (unit.toLowerCase() == 'kg' ? 0.5 : 1.0);
                final qty = units * step;
                final lt = lineTotal(id, units);

                return ListTile(
                  title: Text(name),
                  subtitle: Text('${qty.toStringAsFixed(qty.truncateToDouble()==qty?0:2)} ${unit.toLowerCase()}'),
                  trailing: SizedBox(
                    width: 260,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // decrement units by 1 (equivalent to physical - step)
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: units > 0 ? () => cart.set(id, (units - 1) > 0 ? (units - 1) : 0) : null,
                        ),
                        // editable physical quantity field
                        SizedBox(
                          width: 90,
                          child: TextFormField(
                            initialValue: qty.toStringAsFixed(qty.truncateToDouble()==qty?0:2),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(isDense: true, border: UnderlineInputBorder()),
                            onFieldSubmitted: (v) {
                              final val = double.tryParse(v.replaceAll(',', '.')) ?? qty;
                              final newUnits = (val / step);
                              cart.set(id, newUnits <= 0 ? 0 : newUnits);
                            },
                          ),
                        ),
                        // increment units by 1
                        IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => cart.add(id, by: 1)),
                        const SizedBox(width: 8),
                        // line price
                        Text('${lt.toStringAsFixed(2)} €'),
                        const SizedBox(width: 8),
                        IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => cart.remove(id)),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: ids.isEmpty ? null : SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: FilledButton(
            onPressed: () {
              // Weiter zur Entgegennahme (Selector) — push the selector directly so no named routes required here
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FulfillmentSelectorPage(brand: 'sufru')));
            },
            child: const Text('Entgegennahme wählen'),
          ),
        ),
      ),
    );
  }
}
