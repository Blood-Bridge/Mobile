import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Avatar + name + "Verified since" row at the top of the profile screen.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.verifiedSince,
  });

  final String name;
  final DateTime verifiedSince;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    return parts.take(2).map((e) => e[0]).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM yyyy').format(verifiedSince);

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.accent,
          child: Text(
            _initials,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Verified since $formattedDate',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}
