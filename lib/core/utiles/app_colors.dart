// lib/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Main background for all screens
  static const bg = Color(0xFF0A0A0A);

  // Default readable text on dark background
  static const foreground = Color(0xFFE5E5E5);

  // Background for cards and containers
  static const card = Color(0xFF121212);

  // Secondary darker surface for inner sections
  static const muted = Color(0xFF1F1F1F);

  // Light highlight for secondary elements
  static const accent = Color(0xFF2A2A2A);

  // Background for bottom sheets and popups
  static const popover = Color(0xFF1A1A1A);

  // Background for text fields and inputs
  static const input = Color(0xFF1A1A1A);

  // Main text color
  static const text = foreground;

  // Muted text for subtitles and descriptions
  static const textMuted = Color(0xFFA3A3A3);

  // Primary brand color for buttons and icons
  static const primary = Color(0xFFC97777);
  static const likeprimary = Color(0xFF694040);

  // Text color on primary buttons
  static const primaryForeground = Color(0xFFFFFFFF);

  // Success state color for alerts
  static const success = Color(0xFF5A8A5A);

  // Text color on success messages
  static const successForeground = Color(0xFFFFFFFF);

  // Error or delete action color
  static const destructive = primary;

  // Default border color for cards and inputs
  static const border = Color(0xFF262626);

  // Focus ring color around interactive elements
  static const ring = primary;
}
