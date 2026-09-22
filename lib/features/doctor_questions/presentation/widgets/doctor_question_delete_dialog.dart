import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class DoctorQuestionDeleteDialog extends StatelessWidget {
  final String questionText;

  const DoctorQuestionDeleteDialog({
    super.key,
    required this.questionText,
  });

  static Future<bool?> show(BuildContext context, {required String questionText}) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => DoctorQuestionDeleteDialog(questionText: questionText),
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
              tr('doctor_questions.delete_confirm_title'),
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              tr('doctor_questions.delete_confirm_body'),
              style: AppTypography.bodySmall.copyWith(
                color: context.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: context.dividerColor.withValues(alpha: 0.2),
                borderRadius: AppRadius.cardRadius,
              ),
              child: Text(
                questionText,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.textPrimaryColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.textPrimaryColor,
                      side: BorderSide(color: context.dividerColor),
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.chipRadius,
                      ),
                    ),
                    child: Text(
                      tr('common.cancel'),
                      style: AppTypography.labelLarge,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.chipRadius,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      tr('common.delete'),
                      style: AppTypography.labelLarge.copyWith(
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
