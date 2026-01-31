import 'package:blood_bridge/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Headline Styles
  // Medium-large text styles for section headers

  TextStyle get headline30RegularArimo => TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    fontFamily: 'Arimo',
    color: AppColors.textMuted,
  );

  TextStyle get headline24RegularArimo => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontFamily: 'Arimo',
    color: AppColors.textMuted,
  );

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );

  TextStyle get title20RegularArimo => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    fontFamily: 'Arimo',
    color: AppColors.textMuted,
  );
}
