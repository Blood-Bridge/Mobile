import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/hospital_inventory/domain/entities/hospital_entity.dart';
import 'package:flutter/material.dart';

/// Responsive grid of blood stock cards.
///
/// Shows 2 columns on narrow screens (phones) and 4 columns on
/// wider screens (tablets/landscape), based on available width.
class BloodStockGrid extends StatelessWidget {
  const BloodStockGrid({super.key, required this.items});

  final List<BloodStockEntity> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 500 ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (context, index) => _BloodStockCard(item: items[index]),
        );
      },
    );
  }
}

class _BloodStockCard extends StatelessWidget {
  const _BloodStockCard({required this.item});

  final BloodStockEntity item;

  @override
  Widget build(BuildContext context) {
    final isCritical = item.status == BloodStockStatus.critical;
    final isLow = item.status == BloodStockStatus.low;
    final isWarning = isCritical || isLow;

    final accentColor = isCritical ? AppColors.destructive : AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isWarning ? accentColor.withOpacity(0.12) : AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isWarning ? accentColor : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.bloodtype, size: 16, color: accentColor),
              const SizedBox(width: 4),
              Text(
                item.bloodType,
                style: const TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            '${item.units}',
            style: const TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text(
            isCritical ? 'CRITICAL' : (isLow ? 'LOW STOCK' : 'units available'),
            style: TextStyle(
              color: isWarning ? accentColor : AppColors.textMuted,
              fontSize: 11,
              fontWeight: isWarning ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
