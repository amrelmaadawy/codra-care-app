import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class PatientListShimmer extends StatelessWidget {
  const PatientListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: AppSpacing.pagePadding,
        itemCount: 6,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, _) => Container(
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color: context.dividerColor.withValues(alpha: 0.5),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppShimmerBox(
                  width: 4,
                  height: double.infinity,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            AppShimmerBox(
                              width: 38,
                              height: 38,
                              borderRadius: AppRadius.circleRadius,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: AppShimmerBox(
                                width: 140,
                                height: 16,
                                borderRadius: AppRadius.chipRadius,
                              ),
                            ),
                            SizedBox(width: 8),
                            AppShimmerBox(
                              width: 55,
                              height: 22,
                              borderRadius: AppRadius.chipRadius,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const AppShimmerBox(
                          width: 200,
                          height: 12,
                          borderRadius: AppRadius.chipRadius,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 1,
                          color: context.dividerColor.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppShimmerBox(
                              width: 75,
                              height: 20,
                              borderRadius: AppRadius.chipRadius,
                            ),
                            AppShimmerBox(
                              width: 120,
                              height: 14,
                              borderRadius: AppRadius.chipRadius,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
