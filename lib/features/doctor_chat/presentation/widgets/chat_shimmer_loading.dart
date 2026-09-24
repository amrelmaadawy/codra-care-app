import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class ChatShimmerLoading extends StatelessWidget {
  const ChatShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final isDoctor = index.isOdd;
          return Align(
            alignment: isDoctor ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isDoctor) ...[
                  const AppShimmerBox.circle(size: 32),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Column(
                  crossAxisAlignment:
                      isDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    AppShimmerBox(
                      width: index == 0 ? 180 : (index == 1 ? 240 : 160),
                      height: 52,
                      borderRadius: isDoctor
                          ? AppRadius.buttonRadius.copyWith(
                              bottomRight: const Radius.circular(2),
                            )
                          : AppRadius.buttonRadius.copyWith(
                              bottomLeft: const Radius.circular(2),
                            ),
                    ),
                    const SizedBox(height: 4),
                    const AppShimmerBox(
                      width: 48,
                      height: 12,
                      borderRadius: AppRadius.chipRadius,
                    ),
                  ],
                ),
                if (isDoctor) ...[
                  const SizedBox(width: AppSpacing.xs),
                  const AppShimmerBox.circle(size: 32),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
