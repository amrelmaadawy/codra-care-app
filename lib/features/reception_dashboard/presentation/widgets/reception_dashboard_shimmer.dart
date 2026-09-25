import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import 'reception_queue_shimmer.dart';

class ReceptionDashboardShimmer extends StatelessWidget {
  const ReceptionDashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Appointments Today Grid Skeleton
          const AppShimmerBox(
            width: 130,
            height: 20,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.xs)),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppShimmer(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : 4,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: isMobile ? 1.55 : 1.7,
              ),
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: AppRadius.cardRadius,
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.6),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppShimmerBox(
                          width: 28,
                          height: 28,
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppRadius.sm),
                          ),
                        ),
                        AppShimmerBox(
                          width: 24,
                          height: 24,
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppRadius.xs),
                          ),
                        ),
                      ],
                    ),
                    AppShimmerBox(
                      width: 60,
                      height: 14,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppRadius.xs),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Quick Stats Skeleton
          const AppShimmerBox(
            width: 110,
            height: 20,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.xs)),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppShimmer(
            child: Row(
              children: List.generate(
                2,
                (index) => Expanded(
                  child: Container(
                    margin: EdgeInsetsDirectional.only(
                      end: index == 0 ? AppSpacing.sm : 0,
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: AppRadius.cardRadius,
                      border: Border.all(
                        color: context.dividerColor.withValues(alpha: 0.6),
                      ),
                    ),
                    child: const Row(
                      children: [
                        AppShimmerBox(
                          width: 40,
                          height: 40,
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppRadius.sm),
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppShimmerBox(
                                width: 30,
                                height: 22,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(AppRadius.xs),
                                ),
                              ),
                              SizedBox(height: 4),
                              AppShimmerBox(
                                width: 80,
                                height: 12,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(AppRadius.xs),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Queue Section Skeleton
          const AppShimmerBox(
            width: 140,
            height: 20,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.xs)),
          ),
          const SizedBox(height: AppSpacing.sm),
          const AppShimmerBox(
            width: double.infinity,
            height: AppSizes.minTouchTarget,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
          ),
          const SizedBox(height: AppSpacing.md),
          const ReceptionQueueShimmer(),
        ],
      ),
    );
  }
}
