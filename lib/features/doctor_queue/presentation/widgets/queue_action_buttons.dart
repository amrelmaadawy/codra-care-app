import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

class QueueActionButtons extends StatelessWidget {
  final bool isWaiting;
  final bool isCompleted;
  final bool isCallLoading;
  final bool isCompleteLoading;
  final bool isCancelLoading;
  final bool isExamineLoading;
  final VoidCallback onCall;
  final VoidCallback onComplete;
  final VoidCallback onCancel;
  final VoidCallback? onExamine;

  const QueueActionButtons({
    super.key,
    required this.isWaiting,
    this.isCompleted = false,
    this.isCallLoading = false,
    this.isCompleteLoading = false,
    this.isCancelLoading = false,
    this.isExamineLoading = false,
    required this.onCall,
    required this.onComplete,
    required this.onCancel,
    this.onExamine,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.emerald.withValues(alpha: 0.08),
          borderRadius: AppRadius.buttonRadius,
          border: Border.all(color: AppColors.emerald.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.emerald),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'doctor_queue.visit_completed'.tr(),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.emerald,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        if (isWaiting)
          Expanded(
            child: AppButton(
              labelKey: 'doctor_queue.call_patient',
              icon: Icons.campaign_rounded,
              isLoading: isCallLoading,
              onPressed: onCall,
            ),
          )
        else
          Expanded(
            child: AppButton(
              labelKey: 'doctor_queue.examine',
              icon: Icons.medical_services_outlined,
              isLoading: isExamineLoading,
              onPressed: onExamine ?? onComplete,
            ),
          ),
        const SizedBox(width: AppSpacing.xs),
        _buildOptionsMenu(context),
      ],
    );
  }

  Widget _buildOptionsMenu(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        tooltip: 'doctor_queue.more_options'.tr(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        onSelected: (action) {
          if (action == 'complete') onComplete();
          if (action == 'cancel') onCancel();
        },
        itemBuilder: (ctx) => [
          if (!isWaiting)
            PopupMenuItem(
              value: 'complete',
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 18, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text(
                    'doctor_queue.complete_visit'.tr(),
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          PopupMenuItem(
            value: 'cancel',
            child: Row(
              children: [
                const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error),
                const SizedBox(width: 8),
                Text(
                  'doctor_queue.cancel_visit'.tr(),
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: AppRadius.buttonRadius,
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: (isCompleteLoading || isCancelLoading)
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Color(0xFF94A3B8), shape: BoxShape.circle),
                    ),
                  ),
                )
              : const Icon(
                  Icons.more_vert_rounded,
                  size: 20,
                  color: Color(0xFF64748B),
                ),
        ),
      ),
    );
  }
}
