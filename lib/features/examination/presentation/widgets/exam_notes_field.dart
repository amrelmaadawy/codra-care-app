import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/doctor_template_entity.dart';
import 'exam_template_picker_sheet.dart';

class ExamNotesField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isRequired;
  final List<DoctorTemplateEntity> templates;
  final VoidCallback onChanged;
  final int minLines;

  const ExamNotesField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isRequired = false,
    this.templates = const [],
    required this.onChanged,
    this.minLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.onBackgroundDark : AppColors.onBackgroundLight,
                  ),
                ),
                if (isRequired) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '*',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
            if (templates.isNotEmpty)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    final selected = await ExamTemplatePickerSheet.show(
                      context,
                      templates: templates,
                      title: 'examination.templates'.tr(),
                    );
                    if (selected != null) {
                      controller.text = selected;
                      onChanged();
                    }
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.style_outlined, size: 13, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'examination.templates'.tr(),
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          onChanged: (_) => onChanged(),
          minLines: minLines,
          maxLines: 5,
          style: AppTypography.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.onSurfaceMutedDark : AppColors.onSurfaceMutedLight,
            ),
            filled: true,
            fillColor: isDark ? AppColors.surfaceVariantDark : const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
