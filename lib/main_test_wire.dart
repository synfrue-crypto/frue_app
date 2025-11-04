import 'package:flutter/material.dart';
import 'tests/smoke_test.dart';
import 'core/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init();
  runApp(const MaterialApp(
    home: SmokeTestPage(),
    debugShowCheckedModeBanner: false,
  ));
}
