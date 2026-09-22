import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class ReportsShimmer extends StatelessWidget {
  const ReportsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month filter pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: List.generate(
                  6,
                  (index) => Container(
                    margin: const EdgeInsets.only(left: AppSpacing.sm),
                    child: AppShimmerBox(
                      width: 72,
                      height: 36,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // KPI Stats Row (3 Cards)
            Row(
              children: [
                Expanded(child: _buildCardShimmer(context, height: 90)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildCardShimmer(context, height: 90)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildCardShimmer(context, height: 90)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Chart Card Shimmer
            _buildCardShimmer(context, height: 210),
            const SizedBox(height: AppSpacing.lg),

            // Section title
            const AppShimmerBox(width: 140, height: 20),
            const SizedBox(height: AppSpacing.md),

            // Visit Cards Shimmer
            _buildVisitCardShimmer(context),
            const SizedBox(height: AppSpacing.sm),
            _buildVisitCardShimmer(context),
            const SizedBox(height: AppSpacing.sm),
            _buildVisitCardShimmer(context),
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
          AppShimmerBox(width: double.infinity, height: 14),
          AppShimmerBox(width: 60, height: 18),
        ],
      ),
    );
  }

  Widget _buildVisitCardShimmer(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: const Row(
        children: [
          AppShimmerBox(width: 44, height: 44),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppShimmerBox(width: 120, height: 14),
                SizedBox(height: AppSpacing.xs),
                AppShimmerBox(width: 80, height: 12),
              ],
            ),
          ),
          AppShimmerBox(width: 50, height: 20),
        ],
      ),
    );
  }
}
