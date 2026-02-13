// lib/theme/text_style_helper.dart
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/utiles/extentions.dart';
import 'package:flutter/material.dart';

class AppFonts {
  // Default latin font
  static const String latin = 'Roboto';

  // Default arabic font
  static const String arabic = 'NotoSansArabic';

  // Fallback fonts if primary fails
  static const List<String> fallback = ['Roboto', 'Arimo', 'NotoSansArabic'];
}

class TextStyleHelper {
  // Base text style used by all styles
  static TextStyle _base(
    BuildContext context, {
    required double size,
    required FontWeight weight,
    required Color color,
    double? height,
  }) {
    return TextStyle(
      fontSize: context.sp(size),
      fontWeight: weight,
      color: color,
      height: height ?? 1.5,
      fontFamily: AppFonts.latin,
      fontFamilyFallback: AppFonts.fallback,
    );
  }

  // Large main screen title
  static TextStyle h1(BuildContext context) =>
      _base(context, size: 24, weight: FontWeight.w500, color: AppColors.text);

  // Section title inside screen
  static TextStyle h2(BuildContext context) =>
      _base(context, size: 20, weight: FontWeight.w500, color: AppColors.text);

  // Subtitle inside cards
  static TextStyle h3(BuildContext context) =>
      _base(context, size: 18, weight: FontWeight.w500, color: AppColors.text);

  // Small section title
  static TextStyle h4(BuildContext context) =>
      _base(context, size: 16, weight: FontWeight.w500, color: AppColors.text);

  // Default readable paragraph text
  static TextStyle body(BuildContext context) =>
      _base(context, size: 16, weight: FontWeight.w400, color: AppColors.text);

  // Less prominent paragraph text
  static TextStyle bodyMuted(BuildContext context) => _base(
    context,
    size: 16,
    weight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // Small text inside lists and cards
  static TextStyle small(BuildContext context) => _base(
    context,
    size: 14,
    weight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // Very small text for dates and labels
  static TextStyle xs(BuildContext context) => _base(
    context,
    size: 12,
    weight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // Button text style
  static TextStyle button(BuildContext context) => _base(
    context,
    size: 16,
    weight: FontWeight.w500,
    color: AppColors.primaryForeground,
  );

  // Large blood type or number style
  static TextStyle bloodType(BuildContext context) =>
      _base(context, size: 30, weight: FontWeight.w500, color: AppColors.text);

  // Arabic body text for fully arabic screens
  static TextStyle arabicBody(BuildContext context) => body(context).copyWith(
    fontFamily: AppFonts.arabic,
    fontFamilyFallback: AppFonts.fallback,
  );
}
