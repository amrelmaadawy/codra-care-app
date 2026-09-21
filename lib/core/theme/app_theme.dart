import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static const String _fontFamily = 'Cairo';

  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      onSecondary: AppColors.onAccent,
      error: AppColors.error,
      onSurface: AppColors.onSurfaceLight,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardTheme: const CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.onSurfaceLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: AppSizes.appBarHeight,
        titleTextStyle: AppTypography.headlineMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(AppSizes.minTouchTarget, AppSizes.minTouchTarget),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: AppTypography.labelLarge,
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: AppColors.dividerLight),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: AppColors.dividerLight),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceMutedLight),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceLight),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
      ),
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.surfaceDark,
      secondary: AppColors.accent,
      onSecondary: AppColors.onAccent,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardTheme: const CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.onSurfaceDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: AppSizes.appBarHeight,
        titleTextStyle: AppTypography.headlineMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(AppSizes.minTouchTarget, AppSizes.minTouchTarget),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: AppTypography.labelLarge,
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: AppColors.dividerDark),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: AppColors.dividerDark),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceMutedDark),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceDark),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
      ),
    );
  }
}
