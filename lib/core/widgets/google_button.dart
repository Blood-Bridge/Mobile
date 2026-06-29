import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    super.key,
    required this.height,
    required this.width,
    required this.isEnabled,
  });

  final double height;
  final double width;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    return isEnabled
        ? Container(
            decoration: BoxDecoration(
              color: AppColors.input,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border, width: 2),
            ),
            height: height * 0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: height * 0.06,
                  child: Image.asset('assets/images/google.png'),
                ),
                SizedBox(width: width * 0.03),
                Text(
                  AppLocalizations.of(context)!.continuewithGoogle,
                  style: TextStyleHelper.button(context),
                ),
              ],
            ),
          )
        : Center(
            child: LoadingAnimationWidget.threeRotatingDots(
              color: AppColors.primary,
              size: width * 0.1,
            ),
          );
  }
}
