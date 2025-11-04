import 'package:flutter/material.dart';
import '../core/app_config.dart';
import '../core/logger.dart';
import '../core/data_loader.dart';

class SmokeTestPage extends StatefulWidget {
  const SmokeTestPage({super.key});
  @override
  State<SmokeTestPage> createState() => _SmokeTestPageState();
}

class _SmokeTestPageState extends State<SmokeTestPage> {
  String status = 'Test läuft...';
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    _runTests();
  }

  Future<void> _runTests() async {
    try {
      logs.add('SAFE_MODE = ${AppConfig.drivePrep}');
      Logger.info('Starte Smoke-Test');
  final catalog = await DataLoader.loadCatalog('sufru');
      logs.add('Katalog-Einträge: ${catalog.length}');
      logs.add('DrivePrep = ${AppConfig.drivePrep}');
      setState(() => status = '✅ Alle Tests bestanden');
    } catch (e) {
      Logger.error('Smoke-Test fehlgeschlagen', e);
      setState(() => status = '❌ Fehler: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smoke-Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(status, style: const TextStyle(fontSize: 18)),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (_, i) => Text(logs[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
