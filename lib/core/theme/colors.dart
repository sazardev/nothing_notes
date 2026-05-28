import 'package:flutter/material.dart';

class NothingColors {
  NothingColors._();

  // Dark Mode (Primary — OLED black)
  static const Color black = Color(0xFF000000);
  static const Color surface = Color(0xFF111111);
  static const Color surfaceRaised = Color(0xFF1A1A1A);
  static const Color border = Color(0xFF222222);
  static const Color borderVisible = Color(0xFF333333);
  static const Color textDisabled = Color(0xFF666666);
  static const Color textSecondary = Color(0xFF999999);
  static const Color textPrimary = Color(0xFFE8E8E8);
  static const Color textDisplay = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFD71921);
  static const Color accentSubtle = Color(0x26D71921);
  static const Color success = Color(0xFF4A9E5C);
  static const Color warning = Color(0xFFD4A843);

  // Light Mode
  static const Color lightBlack = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceRaised = Color(0xFFF0F0F0);
  static const Color lightBorder = Color(0xFFE8E8E8);
  static const Color lightBorderVisible = Color(0xFFCCCCCC);
  static const Color lightTextDisabled = Color(0xFF999999);
  static const Color lightTextSecondary = Color(0xFF666666);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextDisplay = Color(0xFF000000);
}

class AppColors {
  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color border;
  final Color borderVisible;
  final Color textDisabled;
  final Color textSecondary;
  final Color textPrimary;
  final Color textDisplay;
  final Color accent;
  final Color accentSubtle;
  final Color success;
  final Color warning;
  final Color interactive;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.border,
    required this.borderVisible,
    required this.textDisabled,
    required this.textSecondary,
    required this.textPrimary,
    required this.textDisplay,
    required this.accent,
    required this.accentSubtle,
    required this.success,
    required this.warning,
    required this.interactive,
  });

  static const AppColors dark = AppColors(
    background: NothingColors.black,
    surface: NothingColors.surface,
    surfaceRaised: NothingColors.surfaceRaised,
    border: NothingColors.border,
    borderVisible: NothingColors.borderVisible,
    textDisabled: NothingColors.textDisabled,
    textSecondary: NothingColors.textSecondary,
    textPrimary: NothingColors.textPrimary,
    textDisplay: NothingColors.textDisplay,
    accent: NothingColors.accent,
    accentSubtle: NothingColors.accentSubtle,
    success: NothingColors.success,
    warning: NothingColors.warning,
    interactive: Color(0xFF5B9BF6),
  );

  static const AppColors light = AppColors(
    background: NothingColors.lightBlack,
    surface: NothingColors.lightSurface,
    surfaceRaised: NothingColors.lightSurfaceRaised,
    border: NothingColors.lightBorder,
    borderVisible: NothingColors.lightBorderVisible,
    textDisabled: NothingColors.lightTextDisabled,
    textSecondary: NothingColors.lightTextSecondary,
    textPrimary: NothingColors.lightTextPrimary,
    textDisplay: NothingColors.lightTextDisplay,
    accent: NothingColors.accent,
    accentSubtle: NothingColors.accentSubtle,
    success: NothingColors.success,
    warning: NothingColors.warning,
    interactive: Color(0xFF007AFF),
  );
}
