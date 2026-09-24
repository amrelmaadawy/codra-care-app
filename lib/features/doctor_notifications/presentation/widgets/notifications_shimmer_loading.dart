import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class NotificationsShimmerLoading extends StatelessWidget {
  const NotificationsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) => const _ShimmerNotificationTile(),
      ),
    );
  }
}

class _ShimmerNotificationTile extends StatelessWidget {
  const _ShimmerNotificationTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.cardRadius,
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmerBox.circle(size: 44),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerBox(
                  width: double.infinity,
                  height: 14,
                  borderRadius: AppRadius.chipRadius,
                ),
                SizedBox(height: AppSpacing.xs),
                AppShimmerBox(
                  width: 200,
                  height: 12,
                  borderRadius: AppRadius.chipRadius,
                ),
                SizedBox(height: AppSpacing.sm),
                AppShimmerBox(
                  width: 80,
                  height: 10,
                  borderRadius: AppRadius.chipRadius,
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          AppShimmerBox.circle(size: 24),
        ],
      ),
    );
  }
}
