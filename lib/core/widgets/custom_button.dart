import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final double borderRadius;
  final bool withArrow;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final bool isEnabled;
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.height,
    this.width = double.infinity,
    this.borderRadius = 10,
    this.withArrow = false,
    this.icon,
    this.iconSize = 24.0,
    this.iconColor = Colors.white,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : () {},
      child: Container(
        height: height ?? MediaQuery.of(context).size.height * 0.07,
        width: width,
        decoration: BoxDecoration(
          color: isEnabled
              ? backgroundColor ?? AppColors.primary
              : AppColors.likeprimary,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  right: withArrow || icon != null ? 50 : 0,
                ),
                child: Text(
                  text,
                  style: TextStyleHelper.small(
                    context,
                  ).copyWith(color: AppColors.foreground),
                ),
              ),
            ),
            if (withArrow)
              const Positioned(
                right: 10,
                child: Icon(
                  CupertinoIcons.arrow_right_circle_fill,
                  size: 50,
                  color: Colors.white,
                ),
              )
            else if (icon != null)
              Positioned(
                right: 10,
                child: Icon(icon, size: iconSize, color: iconColor),
              ),
          ],
        ),
      ),
    );
  }
}
