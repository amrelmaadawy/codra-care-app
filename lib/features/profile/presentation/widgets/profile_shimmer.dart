import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          _buildHeaderShimmer(context),
          const SizedBox(height: AppSpacing.lg),
          _buildInfoCardShimmer(context),
          const SizedBox(height: AppSpacing.lg),
          _buildActionsShimmer(),
        ],
      ),
    );
  }

  Widget _buildHeaderShimmer(BuildContext context) {
    const avatarDimension = AppSizes.avatarLg * 1.5;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: avatarDimension,
            height: avatarDimension,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              shape: BoxShape.circle,
            ),
            child: const AppShimmerBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const AppShimmerBox(width: 160, height: 20),
          const SizedBox(height: AppSpacing.sm),
          const AppShimmerBox(width: 120, height: 14),
          const SizedBox(height: AppSpacing.xs),
          const AppShimmerBox(width: 100, height: 12),
        ],
      ),
    );
  }

  Widget _buildInfoCardShimmer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: List.generate(4, (index) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                AppShimmerBox(width: 24, height: 24),
                SizedBox(width: AppSpacing.md),
                AppShimmerBox(width: 100, height: 14),
                Spacer(),
                AppShimmerBox(width: 120, height: 14),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActionsShimmer() {
    return const Column(
      children: [
        AppShimmerBox(width: double.infinity, height: 48),
        SizedBox(height: AppSpacing.md),
        AppShimmerBox(width: double.infinity, height: 48),
      ],
    );
  }
}
