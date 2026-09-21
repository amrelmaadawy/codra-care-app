import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class PlaceholderShellContent extends StatelessWidget {
  final String titleKey;
  final IconData icon;

  const PlaceholderShellContent({
    super.key,
    required this.titleKey,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSizes.iconXl * 2,
              color: context.primaryColor,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              titleKey.tr(),
              style: AppTypography.headlineMedium.copyWith(
                color: context.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'CodraCare Medical ERP',
              style: AppTypography.bodyMedium.copyWith(
                color: context.textMutedColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
