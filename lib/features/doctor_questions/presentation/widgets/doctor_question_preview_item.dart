import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/doctor_question_entity.dart';
import 'doctor_question_preview_widgets.dart';
import 'doctor_question_type_badge.dart';

class DoctorQuestionPreviewItem extends StatelessWidget {
  final DoctorQuestionEntity question;
  final int number;
  final dynamic currentAnswer;
  final ValueChanged<dynamic> onAnswerChanged;

  const DoctorQuestionPreviewItem({
    super.key,
    required this.question,
    required this.number,
    required this.currentAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number. ',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              ),
              Expanded(
                child: Text(
                  question.text,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.textPrimaryColor,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              DoctorQuestionTypeBadge(type: question.type),
            ],
          ),
          if (question.isRequired) ...[
            const SizedBox(height: 4),
            Text(
              '* ${tr('doctor_questions.badges.required')}',
              style: const TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ],
          const SizedBox(height: 10),
          _buildInput(context),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    switch (question.type) {
      case DoctorQuestionType.text:
        return TextField(
          decoration: InputDecoration(
            hintText: tr('doctor_questions.preview_text_hint'),
            hintStyle: TextStyle(fontSize: 12, color: context.textMutedColor),
            filled: true,
            fillColor: context.surfaceVariantColor.withValues(alpha: 0.45),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.dividerColor.withValues(alpha: 0.45)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.dividerColor.withValues(alpha: 0.45)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.primaryColor, width: 1.4),
            ),
          ),
          onChanged: onAnswerChanged,
        );

      case DoctorQuestionType.yesNo:
        final currentVal = currentAnswer as bool?;
        return Row(
          children: [
            Expanded(
              child: DoctorQuestionYesNoButton(
                label: tr('doctor_questions.yes'),
                icon: Icons.check_rounded,
                color: AppColors.emerald,
                isSelected: currentVal == true,
                onTap: () => onAnswerChanged(true),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: DoctorQuestionYesNoButton(
                label: tr('doctor_questions.no'),
                icon: Icons.close_rounded,
                color: AppColors.error,
                isSelected: currentVal == false,
                onTap: () => onAnswerChanged(false),
              ),
            ),
          ],
        );

      case DoctorQuestionType.multipleChoice:
        final selected = currentAnswer as String?;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: question.options.map((opt) {
            return DoctorQuestionChoicePill(
              label: opt,
              isSelected: selected == opt,
              onTap: () => onAnswerChanged(opt),
            );
          }).toList(),
        );
    }
  }
}
