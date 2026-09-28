import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class PatientPaginationErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const PatientPaginationErrorCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.errorColor.withValues(alpha: 0.06),
          borderRadius: AppRadius.cardRadius,
          border: Border.all(color: context.errorColor.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(AppIcons.error, size: 20, color: context.errorColor),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodySmall.copyWith(
                  color: context.textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            TextButton.icon(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: context.primaryColor,
                minimumSize: const Size(80, 48),
              ),
              icon: const Icon(AppIcons.refresh, size: 16),
              label: Text('patients.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
