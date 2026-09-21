import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class DoctorDashboardShimmer extends StatelessWidget {
  const DoctorDashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    final crossAxisCount = isTablet ? 4 : 2;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 64.0,
        backgroundColor: context.surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: AppSpacing.lg,
        title: Row(
          children: [
            Image.asset(
              AppAssets.logoDarkTransparent,
              height: 34,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Text(
                'app_name'.tr(),
                style: AppTypography.titleLarge.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const AppShimmer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmerBox(width: 120, height: 14, borderRadius: AppRadius.chipRadius),
                  SizedBox(height: 4),
                  AppShimmerBox(width: 160, height: 10, borderRadius: AppRadius.chipRadius),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: context.dividerColor.withValues(alpha: 0.5), height: 1),
        ),
      ),
      body: AppShimmer(
        child: ListView(
          padding: AppSpacing.pagePadding,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: 1.35,
              ),
              itemCount: 6,
              itemBuilder: (context, index) => Container(
                padding: AppSpacing.cardPadding,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.cardRadius,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppShimmerBox(width: 70, height: 12, borderRadius: AppRadius.chipRadius),
                        AppShimmerBox.circle(size: AppSizes.iconLg),
                      ],
                    ),
                    AppShimmerBox(width: 50, height: 22, borderRadius: AppRadius.chipRadius),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppShimmerBox(width: 100, height: 16, borderRadius: AppRadius.chipRadius),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.cardRadius,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.cardRadius,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
