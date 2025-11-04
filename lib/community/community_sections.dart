
import 'package:flutter/material.dart';

class CommunitySections extends StatelessWidget {
  const CommunitySections({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = const [
      _Tile('Pflanzen', Icons.eco_outlined),
      _Tile('Anbau', Icons.grass),
      _Tile('Lernen', Icons.school_outlined),
      _Tile('Küche', Icons.kitchen_outlined),
      _Tile('Orte', Icons.place_outlined),
      _Tile('Klima', Icons.wb_sunny_outlined),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        childAspectRatio: 1.2,
        children: tiles.map((t) => _TileCard(tile: t)).toList(),
      ),
    );
  }
}

class _Tile {
  final String title;
  final IconData icon;
  const _Tile(this.title, this.icon);
}

class _TileCard extends StatelessWidget {
  final _Tile tile;
  const _TileCard({required this.tile});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(tile.title),
            content: const Text('Platzhalter – Inhalte folgen.'),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tile.icon, size: 42),
              const SizedBox(height: 8),
              Text(tile.title),
            ],
          ),
        ),
      ),
    );
  }
}
