import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class QueueCancelDialog extends StatelessWidget {
  final String patientName;
  final String ticketNumber;

  const QueueCancelDialog({
    super.key,
    required this.patientName,
    required this.ticketNumber,
  });

  static Future<bool?> show(BuildContext context, {
    required String patientName,
    required String ticketNumber,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => QueueCancelDialog(
        patientName: patientName,
        ticketNumber: ticketNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'doctor_queue.cancel_confirm_title'.tr(),
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'doctor_queue.cancel_confirm_message'.tr(args: [patientName]),
              style: AppTypography.bodySmall.copyWith(
                color: context.textMutedColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
              decoration: BoxDecoration(
                color: context.backgroundColor,
                borderRadius: AppRadius.cardRadius,
                border: Border.all(
                  color: context.dividerColor.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 14,
                    color: context.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${'doctor_queue.ticket'.tr()}: $ticketNumber',
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.textColor,
                      side: BorderSide(
                        color: context.dividerColor.withValues(alpha: 0.6),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.buttonRadius,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'doctor_queue.keep_ticket'.tr(),
                      style: AppTypography.labelLarge.copyWith(
                        color: context.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.buttonRadius,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'doctor_queue.confirm_cancel'.tr(),
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
