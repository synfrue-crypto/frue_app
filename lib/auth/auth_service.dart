import 'dart:math';
import '../models/user_profile.dart';

/// Abstrakte Auth-Schnittstelle (später kann Karl eine Firebase-Implementierung einhängen).
abstract class AuthService {
  UserProfile? get currentUser;

  /// Email-only „Login“ (lokal). Später von Karl gegen FirebaseAuth.signInWith... tauschen.
  Future<UserProfile> signInWithEmail(String email, {String name = '', String phone = ''});

  Future<void> signOut();

  /// Singleton-Zugriff (aktuell lokal)
  static final AuthService instance = _LocalAuthService();
}

/// Lokale Dummy-Implementierung: Hält Zustand nur im Speicher.
/// Kein Storage, kein Firebase – bricht nichts in der App.
class _LocalAuthService implements AuthService {
  UserProfile? _user;

  @override
  UserProfile? get currentUser => _user;

  @override
  Future<UserProfile> signInWithEmail(String email, {String name = '', String phone = ''}) async {
    // simple UID
    final uid = 'local_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
    _user = UserProfile(uid: uid, name: name, email: email, phone: phone);
    return _user!;
  }

  @override
  Future<void> signOut() async {
    _user = null;
  }
}
