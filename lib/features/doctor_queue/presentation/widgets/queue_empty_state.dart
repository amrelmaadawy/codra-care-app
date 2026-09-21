import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class QueueEmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const QueueEmptyState({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline_rounded,
                size: 64,
                color: context.primaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'doctor_queue.empty_title'.tr(),
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'doctor_queue.empty_subtitle'.tr(),
              style: AppTypography.bodySmall.copyWith(
                color: context.textMutedColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: onRefresh,
              style: OutlinedButton.styleFrom(
                foregroundColor: context.primaryColor,
                backgroundColor: context.primaryColor.withValues(alpha: 0.06),
                side: BorderSide(
                  color: context.primaryColor.withValues(alpha: 0.35),
                  width: 1.2,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.chipRadius,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: 10,
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'common.retry'.tr(),
                style: AppTypography.labelLarge.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
