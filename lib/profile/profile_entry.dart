import 'package:flutter/material.dart';
import 'profile_page.dart';

/// Kleiner Wrapper als Route-Ziel: /profile
class ProfileEntry extends StatelessWidget {
  const ProfileEntry({super.key});

  static const route = '/profile';

  @override
  Widget build(BuildContext context) => const ProfilePage();
}
