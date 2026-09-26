import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class FollowUpShimmerList extends StatelessWidget {
  final int itemCount;

  const FollowUpShimmerList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) => _buildCardShimmer(context),
      ),
    );
  }

  Widget _buildCardShimmer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppShimmerBox(width: 140, height: 16),
              AppShimmerBox(
                width: 80,
                height: 22,
                borderRadius: AppRadius.chipRadius,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const AppShimmerBox(width: 180, height: 12),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.surfaceVariantColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmerBox(width: 120, height: 12),
                AppShimmerBox(width: 60, height: 12),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Row(
            children: [
              AppShimmerBox(
                width: 44,
                height: 38,
                borderRadius: AppRadius.buttonRadius,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppShimmerBox(
                  width: double.infinity,
                  height: 38,
                  borderRadius: AppRadius.buttonRadius,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
