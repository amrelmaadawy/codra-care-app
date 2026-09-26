import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class ChatListShimmer extends StatelessWidget {
  final int count;

  const ChatListShimmer({super.key, this.count = 8});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, _) => Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const Row(
            children: [
              AppShimmerBox.circle(size: 48),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmerBox(width: 130, height: 14),
                    SizedBox(height: AppSpacing.xs),
                    AppShimmerBox(width: 180, height: 12),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppShimmerBox(width: 40, height: 10),
                  SizedBox(height: AppSpacing.xs),
                  AppShimmerBox.circle(size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConversationShimmer extends StatelessWidget {
  final int count;

  const ConversationShimmer({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, index) {
          final isDoctor = index.isEven;
          return Align(
            alignment:
                isDoctor ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmerBox(
                    width: isDoctor ? 90 : 120,
                    height: 12,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const AppShimmerBox(width: 160, height: 12),
                  const SizedBox(height: AppSpacing.xs),
                  const Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: AppShimmerBox(width: 45, height: 10),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
