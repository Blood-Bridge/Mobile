import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';

class BloodTypeIcon extends StatelessWidget {
  const BloodTypeIcon({
    super.key,
    required this.bloodType,
    required this.isSelected,
    required this.height,
    required this.width,
  });
  final String bloodType;
  final bool isSelected;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.input,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: 2,
        ),
      ),
      height: height * 0.06,
      width: width * 0.2,
      child: Center(
        child: Text(bloodType, style: TextStyleHelper.button(context)),
      ),
    );
  }
}
