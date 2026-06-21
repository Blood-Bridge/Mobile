import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/hospital_inventory/domain/entities/hospital_entity.dart';
import 'package:flutter/material.dart';

/// Row showing a nearby donor's distance and blood type badge.
class DonorTile extends StatelessWidget {
  const DonorTile({super.key, required this.donor});

  final NearbyDonorEntity donor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(donor.name, style: const TextStyle(color: AppColors.text, fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  '${donor.distanceKm.toStringAsFixed(1)} km away',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              donor.bloodType,
              style: const TextStyle(color: AppColors.primaryForeground, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
