import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class ReceptionQueueEmptyState extends StatelessWidget {
  final bool isFilteredByDoctor;
  final VoidCallback? onClearFilter;

  const ReceptionQueueEmptyState({
    super.key,
    required this.isFilteredByDoctor,
    this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    final message = isFilteredByDoctor
        ? 'reception_dashboard.empty_queue_doctor'.tr()
        : 'reception_dashboard.empty_queue_all'.tr();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              AppIcons.queue,
              size: AppSizes.iconXl,
              color: context.primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: AppTypography.bodyMedium.copyWith(
              color: context.textMutedColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (isFilteredByDoctor && onClearFilter != null) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: AppSizes.minTouchTarget,
              child: OutlinedButton.icon(
                onPressed: onClearFilter,
                icon: const Icon(AppIcons.refresh, size: AppSizes.iconSm),
                label: Text('reception_dashboard.clear_filter'.tr()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.primaryColor,
                  side: BorderSide(color: context.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
