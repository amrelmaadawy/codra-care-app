import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class AppointmentListShimmer extends StatelessWidget {
  final int itemCount;

  const AppointmentListShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount: itemCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: context.dividerColor),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppShimmerBox(width: 140, height: 16),
                        SizedBox(height: 6),
                        AppShimmerBox(width: 80, height: 12),
                      ],
                    ),
                    AppShimmerBox(
                      width: 70,
                      height: 24,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                AppShimmerBox(width: 200, height: 14),
                SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppShimmerBox(
                      width: 100,
                      height: 22,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    AppShimmerBox(width: 60, height: 18),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
