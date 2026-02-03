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

  // إضافة جديدة لدعم الـ disabled state
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
    this.isEnabled = true, // default true عشان ما يغيرش السلوك القديم
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = isEnabled
        ? (backgroundColor ?? Theme.of(context).primaryColor)
        : (backgroundColor ?? Theme.of(context).primaryColor).withOpacity(0.4);

    final effectiveTextColor = isEnabled
        ? textColor
        : textColor?.withOpacity(0.7);

    final effectiveIconColor = isEnabled
        ? iconColor
        : iconColor?.withOpacity(0.7);

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.65,
      child: GestureDetector(
        onTap: isEnabled ? onPressed : null,
        child: Container(
          height: height ?? MediaQuery.of(context).size.height * 0.07,
          width: width,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            // اختياري: إضافة border لما يكون disabled عشان يبان أكتر
            border: isEnabled
                ? null
                : Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
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
                    style: TextStyle(
                      color: effectiveTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
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
                  child: Icon(icon, size: iconSize, color: effectiveIconColor),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
