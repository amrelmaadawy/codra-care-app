import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class QueueListShimmer extends StatelessWidget {
  final int count;

  const QueueListShimmer({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, _) => _buildCardShimmer(),
      ),
    );
  }

  Widget _buildCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppShimmerBox(
                width: 80,
                height: 24,
                borderRadius: BorderRadius.circular(6),
              ),
              AppShimmerBox(
                width: 60,
                height: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppShimmerBox(
            width: 160,
            height: 18,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppShimmerBox(
            width: 120,
            height: 14,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              AppShimmerBox(
                width: 90,
                height: 28,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppShimmerBox(
                width: 90,
                height: 28,
                borderRadius: BorderRadius.circular(6),
              ),
              const Spacer(),
              AppShimmerBox(
                width: 70,
                height: 32,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
