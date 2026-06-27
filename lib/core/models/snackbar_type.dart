import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SnackbarType {
  error,
  success,
  custom;

  /// الاسم اللي يظهر للمستخدم (تقدر تربطه بالـ localization)
  String get displayName {
    switch (this) {
      case SnackbarType.success:
        return 'Success';
      case SnackbarType.error:
        return 'Error';
      case SnackbarType.custom:
        return 'Custom';
    }
  }

  /// أيقونة الدور
  IconData get icon {
    switch (this) {
      case SnackbarType.success:
        return CupertinoIcons.checkmark_alt_circle_fill;
      case SnackbarType.error:
        return Icons.error;
      case SnackbarType.custom:
        return Icons.error;
    }
  }
}
