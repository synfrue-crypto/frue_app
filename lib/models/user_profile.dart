import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String uid;          // lokal generiert
  final String name;
  final String email;
  final String phone;

  const UserProfile({
    required this.uid,
    this.name = '',
    this.email = '',
    this.phone = '',
  });

  UserProfile copyWith({String? name, String? email, String? phone}) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'phone': phone,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String? ?? 'local',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }
}
