import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class WalkInStageIndicator extends StatelessWidget {
  final int currentStage;
  final ValueChanged<int>? onStageTapped;

  const WalkInStageIndicator({
    super.key,
    required this.currentStage,
    this.onStageTapped,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      (1, 'reception_booking.step_patient'.tr(), Icons.person_rounded),
      (2, 'reception_booking.step_doctor_service'.tr(), Icons.medical_services_rounded),
      (3, 'reception_booking.step_review'.tr(), Icons.fact_check_rounded),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: context.dividerColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            Expanded(
              child: _buildStepItem(
                context,
                index: steps[i].$1,
                label: steps[i].$2,
                icon: steps[i].$3,
              ),
            ),
            if (i < steps.length - 1)
              Container(
                width: 18,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: currentStage > steps[i].$1
                      ? AppColors.emerald
                      : context.dividerColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required int index,
    required String label,
    required IconData icon,
  }) {
    final isCompleted = currentStage > index;
    final isActive = currentStage == index;

    final Color bgColor;
    final Color contentColor;
    final Border border;
    final List<BoxShadow>? shadow;

    if (isActive) {
      bgColor = context.primaryColor;
      contentColor = Colors.white;
      border = Border.all(color: context.primaryColor, width: 1.5);
      shadow = [
        BoxShadow(
          color: context.primaryColor.withValues(alpha: 0.25),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];
    } else if (isCompleted) {
      bgColor = AppColors.emerald.withValues(alpha: 0.12);
      contentColor = AppColors.emerald;
      border = Border.all(color: AppColors.emerald.withValues(alpha: 0.3));
      shadow = null;
    } else {
      bgColor = context.surfaceVariantColor.withValues(alpha: 0.4);
      contentColor = context.textMutedColor;
      border = Border.all(color: context.dividerColor.withValues(alpha: 0.5));
      shadow = null;
    }

    return InkWell(
      onTap: onStageTapped != null ? () => onStageTapped!(index) : null,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: border,
          boxShadow: shadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCompleted ? Icons.check_circle_rounded : icon,
              size: 18,
              color: contentColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: contentColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
