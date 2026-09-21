import 'package:flutter/material.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_shimmer.dart';
import 'app_shimmer_box.dart';

class AppLoadingWidget extends StatelessWidget {
  final String? messageKey;

  const AppLoadingWidget({super.key, this.messageKey});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: AppSpacing.pagePadding,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) => const DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.cardRadius,
          ),
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Row(
              children: [
                AppShimmerBox.circle(size: 40),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmerBox(
                        width: double.infinity,
                        height: 14,
                        borderRadius: AppRadius.chipRadius,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppShimmerBox(
                        width: 120,
                        height: 10,
                        borderRadius: AppRadius.chipRadius,
                      ),
                    ],
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
