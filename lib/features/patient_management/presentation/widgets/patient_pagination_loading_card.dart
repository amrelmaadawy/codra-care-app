import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class PatientPaginationLoadingCard extends StatelessWidget {
  const PatientPaginationLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: AppShimmer(
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: context.dividerColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: const Row(
            children: [
              AppShimmerBox.circle(size: 36),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmerBox(width: 120, height: 14),
                    SizedBox(height: AppSpacing.xs),
                    AppShimmerBox(width: 70, height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
