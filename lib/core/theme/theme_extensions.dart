import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_shadows.dart';

extension ThemeContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  Color get primaryColor => colorScheme.primary;
  Color get onPrimaryColor => colorScheme.onPrimary;
  Color get accentColor => AppColors.accent;

  Color get surfaceColor => isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get backgroundColor => isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
  Color get surfaceVariantColor => isDarkMode ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight;
  Color get dividerColor => isDarkMode ? AppColors.dividerDark : AppColors.dividerLight;

  Color get textColor => isDarkMode ? AppColors.onBackgroundDark : AppColors.onBackgroundLight;
  Color get textMutedColor => isDarkMode ? AppColors.onSurfaceMutedDark : AppColors.onSurfaceMutedLight;

  List<BoxShadow> get primaryShadow => isDarkMode ? const [] : AppShadows.card;
  List<BoxShadow> get elevatedShadow => isDarkMode ? const [] : AppShadows.elevated;
}
