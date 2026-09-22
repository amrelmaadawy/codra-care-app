import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class LeaveDayShimmer extends StatelessWidget {
  const LeaveDayShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                Expanded(child: _buildCardShimmer(context, height: 75)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildCardShimmer(context, height: 75)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildCardShimmer(context, height: 75)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Calendar Shimmer
            _buildCardShimmer(context, height: 350),
            const SizedBox(height: AppSpacing.lg),

            // Upcoming List Section Title
            const AppShimmerBox(width: 140, height: 20),
            const SizedBox(height: AppSpacing.sm),

            // Upcoming Cards Shimmer
            _buildCardShimmer(context, height: 75),
            const SizedBox(height: AppSpacing.sm),
            _buildCardShimmer(context, height: 75),
          ],
        ),
      ),
    );
  }

  Widget _buildCardShimmer(BuildContext context, {required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AppShimmerBox(width: double.infinity, height: 16),
          AppShimmerBox(width: 80, height: 12),
        ],
      ),
    );
  }
}
