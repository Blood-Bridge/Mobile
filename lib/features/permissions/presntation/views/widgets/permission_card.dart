import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';

class PermissionCard extends StatelessWidget {
  const PermissionCard({
    super.key,
    required this.height,
    required this.width,
    required this.title,
    required this.isAccessed,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final double height;
  final double width;
  final bool isAccessed;
  final String title;
  final String description;
  final IconData icon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: isAccessed ? height * 0.2 : height * 0.27,
      width: width,
      decoration: BoxDecoration(
        color: isAccessed ? AppColors.popover : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      duration: Duration(seconds: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            height: height * 0.06,
            width: height * 0.06,
            decoration: BoxDecoration(
              color: isAccessed
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.input,
              borderRadius: BorderRadius.circular(14),
            ),
            duration: Duration(seconds: 1),
            child: Icon(
              icon,
              color: isAccessed ? AppColors.primary : AppColors.textMuted,
            ),
          ),
          SizedBox(width: width * 0.03),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: height * 0.01,
            children: [
              Row(
                children: [
                  Text(title, style: TextStyleHelper.h3(context)),
                  isAccessed
                      ? Icon(Icons.check, color: AppColors.primary)
                      : Container(),
                ],
              ),
              AnimatedContainer(
                width: width * 0.5,
                duration: Duration(seconds: 1),
                child: Text(
                  description,
                  style: TextStyleHelper.xs(context),
                  maxLines: 2,
                ),
              ),
              isAccessed
                  ? Container()
                  : GestureDetector(
                      onTap: onTap,
                      child: AnimatedContainer(
                        width: width * .17,
                        height: width * 0.085,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border, width: 2),
                        ),
                        duration: Duration(seconds: 1),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.allow,
                            style: TextStyleHelper.xs(
                              context,
                            ).copyWith(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
