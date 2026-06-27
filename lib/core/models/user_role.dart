import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum UserRole {
  @JsonValue('Recipient')
  recipient,
  @JsonValue('Donor')
  donor,
  @JsonValue('Hospital')
  hospital;

  String get value => name;

  String get displayName {
    switch (this) {
      case UserRole.donor:
        return 'Donate Blood';
      case UserRole.recipient:
        return 'Request Blood';
      case UserRole.hospital:
        return 'Hospital';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.donor:
        return Icons.bloodtype;
      case UserRole.recipient:
        return Icons.favorite;
      case UserRole.hospital:
        return Icons.local_hospital;
    }
  }

  static UserRole? fromString(String? value) {
    if (value == null) return null;
    final lower = value.toLowerCase();
    return UserRole.values.firstWhere(
      (e) => e.name.toLowerCase() == lower,
      orElse: () => UserRole.donor,
    );
  }
}
