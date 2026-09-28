import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class PatientListShimmer extends StatelessWidget {
  final int count;

  const PatientListShimmer({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    final isTablet = !ResponsiveUtils.isMobile(context);

    return AppShimmer(
      child: isTablet ? _buildGrid(context) : _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, _) => _buildShimmerCard(context),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        mainAxisExtent: 160,
      ),
      itemCount: count,
      itemBuilder: (_, _) => _buildShimmerCard(context),
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: context.dividerColor),
      ),
      padding: AppSpacing.cardPadding,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmerBox.circle(size: 44),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmerBox(width: 140, height: 16),
                    SizedBox(height: AppSpacing.xs),
                    AppShimmerBox(width: 60, height: 12),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              AppShimmerBox(width: 80, height: 20),
              SizedBox(width: AppSpacing.sm),
              AppShimmerBox(width: 50, height: 20),
              SizedBox(width: AppSpacing.sm),
              AppShimmerBox(width: 60, height: 20),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Divider(height: 1),
          SizedBox(height: AppSpacing.sm),
          AppShimmerBox(width: 130, height: 14),
        ],
      ),
    );
  }
}
