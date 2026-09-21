import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class PatientDetailShimmer extends StatelessWidget {
  const PatientDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              context,
              child: Column(
                children: [
                  const Row(
                    children: [
                      AppShimmerBox(
                        width: 48,
                        height: 48,
                        borderRadius: AppRadius.circleRadius,
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppShimmerBox(
                              width: 140,
                              height: 18,
                              borderRadius: AppRadius.chipRadius,
                            ),
                            SizedBox(height: 6),
                            AppShimmerBox(
                              width: 70,
                              height: 14,
                              borderRadius: AppRadius.chipRadius,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    height: 1,
                    color: context.dividerColor.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Row(
                    children: [
                      AppShimmerBox(
                        width: 120,
                        height: 14,
                        borderRadius: AppRadius.chipRadius,
                      ),
                      SizedBox(width: AppSpacing.md),
                      AppShimmerBox(
                        width: 100,
                        height: 14,
                        borderRadius: AppRadius.chipRadius,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: List.generate(
                4,
                (index) => Expanded(
                  child: Container(
                    margin: EdgeInsetsDirectional.only(
                      end: index < 3 ? AppSpacing.xs : 0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: AppRadius.cardRadius,
                      border: Border.all(
                        color: context.dividerColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Column(
                      children: [
                        AppShimmerBox(
                          width: 24,
                          height: 24,
                          borderRadius: AppRadius.circleRadius,
                        ),
                        SizedBox(height: 6),
                        AppShimmerBox(
                          width: 30,
                          height: 14,
                          borderRadius: AppRadius.chipRadius,
                        ),
                        SizedBox(height: 4),
                        AppShimmerBox(
                          width: 45,
                          height: 10,
                          borderRadius: AppRadius.chipRadius,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildCard(
              context,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmerBox(
                    width: 130,
                    height: 16,
                    borderRadius: AppRadius.chipRadius,
                  ),
                  SizedBox(height: AppSpacing.md),
                  AppShimmerBox(
                    width: double.infinity,
                    height: 38,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  AppShimmerBox(
                    width: double.infinity,
                    height: 38,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildCard(
              context,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmerBox(
                    width: 160,
                    height: 16,
                    borderRadius: AppRadius.chipRadius,
                  ),
                  SizedBox(height: AppSpacing.md),
                  AppShimmerBox(
                    width: double.infinity,
                    height: 70,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: child,
    );
  }
}
