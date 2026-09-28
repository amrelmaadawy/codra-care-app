import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class ReceptionPaymentShimmer extends StatelessWidget {
  const ReceptionPaymentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: context.dividerColor.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                AppShimmerBox(
                  width: 38,
                  height: 38,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmerBox(
                      width: 130,
                      height: 16,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    const SizedBox(height: 5),
                    AppShimmerBox(
                      width: 80,
                      height: 12,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ],
                ),
                const Spacer(),
                const AppShimmerBox.circle(size: 30),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Divider(height: 1, color: context.dividerColor.withValues(alpha: 0.25)),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.surfaceVariantColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.dividerColor.withValues(alpha: 0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppShimmerBox(
                        width: 80,
                        height: 12,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      AppShimmerBox(
                        width: 60,
                        height: 20,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppShimmerBox(
                    width: 120,
                    height: 24,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Divider(height: 1, color: context.dividerColor.withValues(alpha: 0.2)),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: List.generate(
                      3,
                      (i) => Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppShimmerBox(
                              width: 50,
                              height: 10,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            const SizedBox(height: 4),
                            AppShimmerBox(
                              width: 65,
                              height: 13,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: List.generate(
                3,
                (i) => Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: i < 2 ? AppSpacing.xs : 0,
                    ),
                    child: AppShimmerBox(
                      height: 36,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: context.surfaceVariantColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.dividerColor.withValues(alpha: 0.2)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppShimmerBox(
              width: double.infinity,
              height: 46,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
