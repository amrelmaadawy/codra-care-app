import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class ReceptionQueueShimmer extends StatelessWidget {
  final int count;

  const ReceptionQueueShimmer({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: List.generate(count, (index) => const _QueueCardSkeleton()),
      ),
    );
  }
}

class _QueueCardSkeleton extends StatelessWidget {
  const _QueueCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppShimmerBox(
                width: 44,
                height: 24,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: AppShimmerBox(
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.xs)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              AppShimmerBox(
                width: 48,
                height: 20,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Row(
            children: [
              AppShimmerBox(
                width: AppSizes.iconSm,
                height: AppSizes.iconSm,
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.xs)),
              ),
              SizedBox(width: AppSpacing.xs),
              AppShimmerBox(
                width: 120,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.xs)),
              ),
              SizedBox(width: AppSpacing.md),
              AppShimmerBox(
                width: 70,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.xs)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  AppShimmerBox(
                    width: AppSizes.iconSm,
                    height: AppSizes.iconSm,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppRadius.xs),
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  AppShimmerBox(
                    width: 60,
                    height: 12,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppRadius.xs),
                    ),
                  ),
                ],
              ),
              AppShimmerBox(
                width: 72,
                height: 20,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
