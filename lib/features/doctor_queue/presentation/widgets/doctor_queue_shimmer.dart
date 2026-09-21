import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class DoctorQueueShimmer extends StatelessWidget {
  const DoctorQueueShimmer({super.key});

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppShimmerBox(width: 140, height: 16, borderRadius: AppRadius.chipRadius),
                  SizedBox(height: 4),
                  AppShimmerBox(width: 180, height: 11, borderRadius: AppRadius.chipRadius),
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
            // Summary strip shimmer
            Row(
              children: List.generate(4, (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 3 ? AppSpacing.sm : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.cardRadius,
                  ),
                  child: const Column(
                    children: [
                      AppShimmerBox(width: 24, height: 18, borderRadius: AppRadius.chipRadius),
                      SizedBox(height: 6),
                      AppShimmerBox(width: 44, height: 10, borderRadius: AppRadius.chipRadius),
                    ],
                  ),
                ),
              )),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Patient cards shimmer
            ...List.generate(3, (index) => Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: AppSpacing.cardPadding,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.cardRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppShimmerBox(width: 110, height: 14, borderRadius: AppRadius.chipRadius),
                              SizedBox(height: 4),
                              AppShimmerBox(width: 70, height: 10, borderRadius: AppRadius.chipRadius),
                            ],
                          ),
                        ],
                      ),
                      const AppShimmerBox(width: 60, height: 24, borderRadius: AppRadius.chipRadius),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const AppShimmerBox(width: double.infinity, height: 1, borderRadius: BorderRadius.zero),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppRadius.buttonRadius,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppRadius.buttonRadius,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
