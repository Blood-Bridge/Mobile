import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';

/// Green checkmark badge shown on the "Request Sent" confirmation screen.
class SuccessBadge extends StatelessWidget {
  const SuccessBadge({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.success, width: 2),
      ),
      child: Icon(Icons.check, color: AppColors.success, size: size * 0.5),
    );
  }
}
