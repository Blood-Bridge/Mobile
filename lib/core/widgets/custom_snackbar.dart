import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';

void showSnackBar(
  String titleText,
  String message,
  SnackbarType type, {
  IconData? icon,
}) {
  void show() {
    Get.showSnackbar(
      GetSnackBar(
        title: titleText,
        messageText: Text(
          message,
          style: const TextStyle(color: AppColors.foreground),
        ),
        icon: type == SnackbarType.success
            ? Icon(type.icon, color: AppColors.foreground)
            : type == SnackbarType.error
            ? Icon(type.icon, color: AppColors.foreground)
            : Icon(icon, color: AppColors.foreground),
        backgroundColor: AppColors.popover,
        borderColor: AppColors.border,
        borderRadius: 8,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  // آمن ضد build/transition
  if (Get.overlayContext == null) {
    WidgetsBinding.instance.addPostFrameCallback((_) => show());
  } else {
    show();
  }
}
