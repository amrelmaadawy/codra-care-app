import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';

class FollowUpEmptyState extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onResetFilters;

  const FollowUpEmptyState({
    super.key,
    required this.hasFilters,
    required this.onResetFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.surfaceVariantColor.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 48,
                color: context.primaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              hasFilters
                  ? 'reception_follow_ups.no_results'.tr()
                  : 'reception_follow_ups.all_caught_up'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              hasFilters
                  ? 'reception_follow_ups.no_results_desc'.tr()
                  : 'reception_follow_ups.all_caught_up_desc'.tr(),
              style: TextStyle(
                fontSize: 13,
                color: context.textMutedColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: onResetFilters,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text('reception_follow_ups.reset_filters'.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
