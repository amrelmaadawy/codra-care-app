import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_extensions.dart';
import 'app_shimmer.dart';

enum AppButtonVariant { primary, secondary, outlined, text }

class AppButton extends StatelessWidget {
  final String labelKey;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final IconData? icon;
  final double? width;

  const AppButton({
    super.key,
    required this.labelKey,
    this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget child;
    if (isLoading) {
      final shimmerColor = (variant == AppButtonVariant.primary ||
              variant == AppButtonVariant.secondary)
          ? Colors.white
          : context.primaryColor;
      child = AppShimmer(
        baseColor: shimmerColor.withValues(alpha: 0.35),
        highlightColor: shimmerColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: shimmerColor, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Container(width: 8, height: 8, decoration: BoxDecoration(color: shimmerColor, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Container(width: 8, height: 8, decoration: BoxDecoration(color: shimmerColor, shape: BoxShape.circle)),
          ],
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSizes.iconMd),
          const SizedBox(width: AppSpacing.sm),
          Text(labelKey.tr()),
        ],
      );
    } else {
      child = Text(labelKey.tr());
    }

    Widget buttonWidget;
    switch (variant) {
      case AppButtonVariant.primary:
        buttonWidget = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.primaryColor,
            foregroundColor: AppColors.onPrimary,
            minimumSize: const Size(AppSizes.minTouchTarget, AppSizes.minTouchTarget),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
            textStyle: AppTypography.labelLarge,
          ),
          child: child,
        );
        break;
      case AppButtonVariant.secondary:
        buttonWidget = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
            minimumSize: const Size(AppSizes.minTouchTarget, AppSizes.minTouchTarget),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
            textStyle: AppTypography.labelLarge,
          ),
          child: child,
        );
        break;
      case AppButtonVariant.outlined:
        buttonWidget = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: context.primaryColor,
            side: BorderSide(color: context.primaryColor),
            minimumSize: const Size(AppSizes.minTouchTarget, AppSizes.minTouchTarget),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
            textStyle: AppTypography.labelLarge,
          ),
          child: child,
        );
        break;
      case AppButtonVariant.text:
        buttonWidget = TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: context.primaryColor,
            minimumSize: const Size(AppSizes.minTouchTarget, AppSizes.minTouchTarget),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
            textStyle: AppTypography.labelLarge,
          ),
          child: child,
        );
        break;
    }

    if (width != null) {
      return SizedBox(width: width, child: buttonWidget);
    }
    return buttonWidget;
  }
}
