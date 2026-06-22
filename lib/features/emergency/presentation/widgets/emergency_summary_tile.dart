import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';

/// A single labeled row on the "Confirm Emergency" screen, e.g.
/// "Blood Type — A+" or "Location — Current location".
class EmergencySummaryTile extends StatelessWidget {
  const EmergencySummaryTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primary.withOpacity(0.12) : AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: highlighted ? AppColors.primary : AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: AppColors.text, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
