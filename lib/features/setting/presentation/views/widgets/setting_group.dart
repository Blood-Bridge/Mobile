import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';

class SettingsGroup extends StatelessWidget {
  final String sectionTitle;
  final List<Widget> children;

  const SettingsGroup({
    super.key,
    required this.sectionTitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              sectionTitle.toUpperCase(),
              style: TextStyleHelper.xs(
                context,
              ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w600),
            ),
          ),
          for (int i = 0; i < children.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i < children.length - 1 ? 8 : 0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: children[i],
              ),
            ),
        ],
      ),
    );
  }
}
