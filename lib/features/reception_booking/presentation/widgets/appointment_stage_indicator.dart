import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class AppointmentStageIndicator extends StatelessWidget {
  final int currentStage;
  final ValueChanged<int>? onStageTapped;

  const AppointmentStageIndicator({
    super.key,
    required this.currentStage,
    this.onStageTapped,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      (1, 'reception_booking.step_patient'.tr(), Icons.person_outline),
      (
        2,
        'reception_booking.step_schedule'.tr(),
        Icons.calendar_today_outlined,
      ),
      (3, 'reception_booking.step_review'.tr(), Icons.check_circle_outline),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(bottom: BorderSide(color: context.dividerColor)),
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
                width: 20,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                color: currentStage > steps[i].$1
                    ? context.primaryColor
                    : context.dividerColor,
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

    final Color color = isActive
        ? context.primaryColor
        : (isCompleted ? AppColors.emerald : context.textMutedColor);

    return InkWell(
      onTap: onStageTapped != null ? () => onStageTapped!(index) : null,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? context.primaryColor
                    : (isCompleted
                          ? AppColors.emerald.withValues(alpha: 0.15)
                          : context.surfaceVariantColor),
                border: Border.all(color: color, width: isActive ? 2 : 1),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.emerald,
                      )
                    : Icon(
                        icon,
                        size: 14,
                        color: isActive ? Colors.white : context.textMutedColor,
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: color,
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
