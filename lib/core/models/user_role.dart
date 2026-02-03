import 'package:flutter/material.dart';

enum UserRole {
  donor,
  requester,
  hospital;

  /// القيمة اللي تتحفظ في Hive / API
  String get value => name;

  /// الاسم اللي يظهر للمستخدم (تقدر تربطه بالـ localization)
  String get displayName {
    switch (this) {
      case UserRole.donor:
        return 'Donate Blood';
      case UserRole.requester:
        return 'Request Blood';
      case UserRole.hospital:
        return 'Hospital';
    }
  }

  /// أيقونة الدور
  IconData get icon {
    switch (this) {
      case UserRole.donor:
        return Icons.bloodtype;
      case UserRole.requester:
        return Icons.favorite;
      case UserRole.hospital:
        return Icons.local_hospital;
    }
  }

  /// تحويل من String (جاية من Hive)
  static UserRole? fromString(String? value) {
    if (value == null) return null;

    return UserRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserRole.donor, // fallback آمن
    );
  }
}
