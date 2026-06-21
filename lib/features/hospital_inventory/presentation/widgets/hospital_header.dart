import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';

/// Hospital name, department, and a row of 3 quick-stat cards.
class HospitalHeader extends StatelessWidget {
  const HospitalHeader({
    super.key,
    required this.name,
    required this.department,
    required this.totalUnits,
    required this.activeRequestsCount,
    required this.criticalTypesCount,
  });

  final String name;
  final String department;
  final int totalUnits;
  final int activeRequestsCount;
  final int criticalTypesCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(department, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _StatCard(label: 'Total Units', value: '$totalUnits units')),
            const SizedBox(width: 8),
            Expanded(child: _StatCard(label: 'Active Requests', value: '$activeRequestsCount')),
            const SizedBox(width: 8),
            Expanded(child: _StatCard(label: 'Critical Types', value: '$criticalTypesCount')),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}
