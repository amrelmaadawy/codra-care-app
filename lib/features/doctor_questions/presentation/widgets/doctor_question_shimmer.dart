import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class DoctorQuestionShimmer extends StatelessWidget {
  const DoctorQuestionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: AppSpacing.pagePadding,
        itemCount: 6,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, _) => Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color: context.dividerColor.withValues(alpha: 0.5),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AppShimmerBox(
                        width: 24,
                        height: 24,
                        borderRadius: AppRadius.chipRadius,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      AppShimmerBox(
                        width: 90,
                        height: 22,
                        borderRadius: AppRadius.chipRadius,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      AppShimmerBox(
                        width: 50,
                        height: 22,
                        borderRadius: AppRadius.chipRadius,
                      ),
                    ],
                  ),
                  AppShimmerBox(
                    width: 36,
                    height: 20,
                    borderRadius: AppRadius.chipRadius,
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              AppShimmerBox(
                width: double.infinity,
                height: 14,
                borderRadius: AppRadius.chipRadius,
              ),
              SizedBox(height: 6),
              AppShimmerBox(
                width: 180,
                height: 14,
                borderRadius: AppRadius.chipRadius,
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppShimmerBox(
                    width: 70,
                    height: 28,
                    borderRadius: AppRadius.buttonRadius,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  AppShimmerBox(
                    width: 70,
                    height: 28,
                    borderRadius: AppRadius.buttonRadius,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
