import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  final AppColors colors;

  AppTheme({required this.colors});

  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        brightness: colors == AppColors.dark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: colors.background,
        colorScheme: ColorScheme(
          brightness: colors == AppColors.dark ? Brightness.dark : Brightness.light,
          primary: colors.textDisplay,
          onPrimary: colors.background,
          secondary: colors.textSecondary,
          onSecondary: colors.textPrimary,
          error: colors.accent,
          onError: colors.textDisplay,
          surface: colors.surface,
          onSurface: colors.textPrimary,
        ),
        textTheme: TextTheme(
          displayLarge: NothingTypography.displayLg(colors.textDisplay),
          displayMedium: NothingTypography.displayMd(colors.textDisplay),
          headlineLarge: NothingTypography.heading(colors.textPrimary),
          headlineMedium: NothingTypography.subheading(colors.textPrimary),
          bodyLarge: NothingTypography.body(colors.textPrimary),
          bodyMedium: NothingTypography.bodySmall(colors.textSecondary),
          labelLarge: NothingTypography.button(colors.textPrimary),
          labelSmall: NothingTypography.caption(colors.textSecondary),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: colors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: colors.textPrimary),
          titleTextStyle: NothingTypography.heading(colors.textDisplay),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: colors.surface,
          selectedItemColor: colors.textDisplay,
          unselectedItemColor: colors.textDisabled,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dividerTheme: DividerThemeData(
          color: colors.border,
          thickness: 1,
          space: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.borderVisible),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.borderVisible),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.textPrimary, width: 2),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.accent),
          ),
          labelStyle: NothingTypography.label(colors.textSecondary),
          hintStyle: NothingTypography.body(colors.textDisabled),
        ),
      );

  static AppTheme dark() => AppTheme(colors: AppColors.dark);
  static AppTheme light() => AppTheme(colors: AppColors.light);
}
