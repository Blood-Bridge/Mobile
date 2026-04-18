import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';

class ArrowItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const ArrowItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyleHelper.body(context)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(subtitle!, style: TextStyleHelper.small(context)),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
