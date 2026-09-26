import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';

class FollowUpInstructionsSection extends StatelessWidget {
  final String instructions;
  final bool isExpanded;
  final VoidCallback onToggle;

  const FollowUpInstructionsSection({
    super.key,
    required this.instructions,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.infoLight.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: AppColors.info,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'reception_follow_ups.doctor_instructions'.tr(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.info,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 16,
                  color: AppColors.info,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                instructions,
                style: TextStyle(
                  fontSize: 12,
                  color: context.textColor,
                  height: 1.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
