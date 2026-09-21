import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'exam_image_picker_sheet.dart';

class ExamImageEmptyState extends StatelessWidget {
  final void Function(List<String> paths, String type, String? description) onUpload;

  const ExamImageEmptyState({
    super.key,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => ExamImagePickerSheet.show(context, onUpload: onUpload),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark.withValues(alpha: 0.4) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_photo_alternate_outlined, size: 28, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'examination.no_images'.tr(),
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.onSurfaceDark : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'examination.tap_to_add_image'.tr(),
              style: AppTypography.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
