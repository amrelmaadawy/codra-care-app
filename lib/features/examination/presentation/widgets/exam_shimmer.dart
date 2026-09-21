import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class ExamShimmer extends StatelessWidget {
  const ExamShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppShimmerBox(width: double.infinity, height: 110),
            SizedBox(height: AppSpacing.md),
            AppShimmerBox(width: double.infinity, height: 90),
            SizedBox(height: AppSpacing.md),
            AppShimmerBox(width: double.infinity, height: 160),
            SizedBox(height: AppSpacing.md),
            AppShimmerBox(width: double.infinity, height: 200),
            SizedBox(height: AppSpacing.md),
            AppShimmerBox(width: double.infinity, height: 120),
            SizedBox(height: AppSpacing.md),
            AppShimmerBox(width: double.infinity, height: 100),
            SizedBox(height: AppSpacing.lg),
            AppShimmerBox(width: double.infinity, height: 48),
          ],
        ),
      ),
    );
  }
}
