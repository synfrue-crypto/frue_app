
import 'package:flutter/material.dart';
import '../core/data_loader.dart';
import 'cart_model.dart';
import 'fulfillment_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class FulfillmentSelectorPage extends StatefulWidget {
  final String brand;
  const FulfillmentSelectorPage({super.key, required this.brand});

  @override
  State<FulfillmentSelectorPage> createState() => _FulfillmentSelectorPageState();
}

class _FulfillmentSelectorPageState extends State<FulfillmentSelectorPage> {
  List<Map<String,dynamic>> _list = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DataLoader.loadFulfillment(widget.brand);
    final casted = data.map<Map<String,dynamic>>((e) => Map<String,dynamic>.from(e as Map)).toList();
    setState(() {
      _list = casted;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Abholstelle wählen')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _list.isEmpty
              ? const Center(child: Text('Keine Abholstellen hinterlegt.'))
              : ListView.separated(
                  itemCount: _list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final m = _list[i];
                    final title = m['label']?.toString() ?? m['name']?.toString() ?? 'Abholstelle';
                    final addr = m['address']?.toString() ?? '';
                    final hours = m['opening_hours']?.toString() ?? '';
                    final url = addr.isNotEmpty ? toMapUrl(addr) : null;

                    return ListTile(
                      title: Text(title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (addr.isNotEmpty) Text(addr),
                          if (hours.isNotEmpty) Text(hours, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (url != null) IconButton(
                            tooltip: 'Karte öffnen',
                            icon: const Icon(Icons.map_outlined),
                            onPressed: () async {
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () async {
                        cart.setFulfillment(m);
                        // timeslot optional
                        final slots = buildTimeslotsFrom(m);
                        if (slots.isEmpty) {
                          Navigator.pop(context, m);
                          return;
                        }
                        final picked = await Navigator.push<Map<String,dynamic>>(
                          context, MaterialPageRoute(builder: (_) => TimeslotPickerPage(slots: slots)));
                        if (picked != null) {
                          cart.setTimeslot(picked);
                        }
                        if (context.mounted) Navigator.pop(context, m);
                      },
                    );
                  },
                ),
    );
  }
}

class TimeslotPickerPage extends StatelessWidget {
  final List<Map<String,String>> slots;
  const TimeslotPickerPage({super.key, required this.slots});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zeitslot wählen')),
      body: ListView.separated(
        itemCount: slots.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final s = slots[i];
          return ListTile(
            title: Text(s['label'] ?? 'Slot'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pop(context, {'id': s['id'] ?? 'slot', 'label': s['label'] ?? ''}),
          );
        },
      ),
    );
  }
}
