import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';

/// Highlighted card showing the donor's blood type.
class BloodTypeCard extends StatelessWidget {
  const BloodTypeCard({super.key, required this.bloodType});

  final String bloodType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.likeprimary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.bloodtype, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text(
            'Blood Type',
            style: TextStyle(color: AppColors.text, fontSize: 13),
          ),
          const Spacer(),
          Text(
            bloodType,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
