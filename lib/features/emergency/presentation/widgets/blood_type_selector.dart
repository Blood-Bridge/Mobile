import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';

/// Grid of selectable blood-type chips (A+, A-, B+, ... AB).
class BloodTypeSelector extends StatelessWidget {
  const BloodTypeSelector({
    super.key,
    required this.bloodTypes,
    required this.selected,
    required this.onSelected,
  });

  final List<String> bloodTypes;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 500 ? 6 : 4;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bloodTypes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (context, index) {
            final type = bloodTypes[index];
            final isSelected = type == selected;
            return GestureDetector(
              onTap: () => onSelected(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryForeground : AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
