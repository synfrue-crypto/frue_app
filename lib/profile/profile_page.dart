import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../models/user_profile.dart';
import '../theme/brand_theme.dart'; // nutzt eure Farben/Typo

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _emailCtrl = TextEditingController();
  final _nameCtrl  = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    const brand = 'sufru'; // Farbwelt warm – kann Karl später dynamisieren
    final color = BrandTheme.colorFor(brand);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dein Profil'),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: user == null ? _buildSignIn(context, color) : _buildProfile(context, color, user),
          ),
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle('Anmelden', color: color),
        const SizedBox(height: 8),
        Text(
          'Melde dich an, um deine Daten beim Checkout vorauszufüllen (Name, E-Mail, Telefon). '
          'Das ist aktuell eine einfache lokale Anmeldung – später tauschen wir das gegen Firebase.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
        const SizedBox(height: 8),
        TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'E-Mail')),
        const SizedBox(height: 8),
        TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Telefon')),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () async {
            if (_emailCtrl.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bitte E-Mail eingeben')));
              return;
            }
            await AuthService.instance.signInWithEmail(
              _emailCtrl.text.trim(),
              name: _nameCtrl.text.trim(),
              phone: _phoneCtrl.text.trim(),
            );
            if (mounted) setState(() {});
          },
          child: const Text('Anmelden'),
        ),
      ],
    );
  }

  Widget _buildProfile(BuildContext context, Color color, UserProfile user) {
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54);
    final valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle('Profil', color: color),
        const SizedBox(height: 8),
        _Row('Name', user.name, labelStyle, valueStyle),
        _Row('E-Mail', user.email, labelStyle, valueStyle),
        _Row('Telefon', user.phone, labelStyle, valueStyle),
        const SizedBox(height: 16),
        Row(
          children: [
            FilledButton.tonal(
              onPressed: () => setState(() {}),
              child: const Text('Aktualisieren'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () async {
                await AuthService.instance.signOut();
                if (mounted) setState(() {});
              },
              child: const Text('Abmelden'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Hinweis: Diese Anmeldung ist aktuell lokal. Später wird sie durch Firebase Auth ersetzt '
          'und mit Checkout/Drive verknüpft.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionTitle(this.text, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? ls;
  final TextStyle? vs;
  const _Row(this.label, this.value, this.ls, this.vs);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: ls)),
          Expanded(child: Text(value.isEmpty ? '—' : value, style: vs)),
        ],
      ),
    );
  }
}
