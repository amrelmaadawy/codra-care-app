import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/doctor_question_entity.dart';

class ExamQuestionItem extends StatelessWidget {
  final DoctorQuestionEntity question;
  final String currentAnswer;
  final void Function(String answer) onAnswerChanged;

  const ExamQuestionItem({
    super.key,
    required this.question,
    required this.currentAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: question.questionText,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.onBackgroundDark : AppColors.onBackgroundLight,
              ),
              children: [
                if (question.isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildAnswerField(isDark),
        ],
      ),
    );
  }

  Widget _buildAnswerField(bool isDark) {
    if (question.isYesNo) {
      return Row(
        children: [
          _buildOptionBtn(
            label: 'examination.yes_answer'.tr(),
            isSelected: currentAnswer == 'yes',
            selectedColor: AppColors.success,
            icon: Icons.check_circle_rounded,
            isDark: isDark,
            onTap: () => onAnswerChanged(currentAnswer == 'yes' ? '' : 'yes'),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildOptionBtn(
            label: 'examination.no_answer'.tr(),
            isSelected: currentAnswer == 'no',
            selectedColor: AppColors.error,
            icon: Icons.cancel_rounded,
            isDark: isDark,
            onTap: () => onAnswerChanged(currentAnswer == 'no' ? '' : 'no'),
          ),
        ],
      );
    }

    if (question.isMultipleChoice && question.options.isNotEmpty) {
      return Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: question.options.map((opt) {
          final isSelected = currentAnswer == opt;
          return _buildOptionBtn(
            label: opt,
            isSelected: isSelected,
            selectedColor: AppColors.primary,
            icon: Icons.check_rounded,
            isDark: isDark,
            onTap: () => onAnswerChanged(isSelected ? '' : opt),
          );
        }).toList(),
      );
    }

    return TextFormField(
      initialValue: currentAnswer,
      onChanged: onAnswerChanged,
      maxLines: 2,
      minLines: 1,
      style: AppTypography.bodySmall,
      decoration: InputDecoration(
        hintText: 'examination.question_text_hint'.tr(),
        hintStyle: AppTypography.caption.copyWith(
          color: isDark ? AppColors.onSurfaceMutedDark : AppColors.onSurfaceMutedLight,
        ),
        prefixIcon: const Icon(Icons.edit_note_rounded, size: 20, color: AppColors.primary),
        filled: true,
        fillColor: isDark ? AppColors.surfaceVariantDark : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildOptionBtn({
    required String label,
    required bool isSelected,
    required Color selectedColor,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final bg = isSelected ? selectedColor : (isDark ? AppColors.surfaceVariantDark : const Color(0xFFF8FAFC));
    final border = isSelected ? selectedColor : (isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0));
    final textCol = isSelected ? Colors.white : (isDark ? AppColors.onSurfaceDark : const Color(0xFF475569));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border, width: 1.2),
            boxShadow: isSelected
                ? [BoxShadow(color: selectedColor.withValues(alpha: 0.25), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Icon(icon, size: 15, color: Colors.white),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: textCol,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
