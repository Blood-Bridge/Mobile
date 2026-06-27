import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';

class ArrowItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;

  const ArrowItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: icon != null
          ? Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.textMuted).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor ?? AppColors.textMuted, size: 18),
            )
          : null,
      title: Text(title, style: TextStyleHelper.small(context)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: TextStyleHelper.xs(context)
                  .copyWith(color: AppColors.textMuted))
          : null,
      trailing: Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
    );
  }
}
