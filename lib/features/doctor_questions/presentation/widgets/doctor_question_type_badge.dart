import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/doctor_question_entity.dart';

class DoctorQuestionTypeBadge extends StatelessWidget {
  final DoctorQuestionType type;

  const DoctorQuestionTypeBadge({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final (color, bgColor, icon, labelKey) = switch (type) {
      DoctorQuestionType.text => (
          AppColors.info,
          isDark ? AppColors.info.withValues(alpha: 0.15) : AppColors.infoLight,
          Icons.text_fields_rounded,
          'doctor_questions.types.text',
        ),
      DoctorQuestionType.yesNo => (
          AppColors.emerald,
          isDark ? AppColors.emerald.withValues(alpha: 0.15) : AppColors.emeraldLight,
          Icons.check_circle_outline_rounded,
          'doctor_questions.types.yes_no',
        ),
      DoctorQuestionType.multipleChoice => (
          AppColors.accent,
          isDark ? AppColors.accent.withValues(alpha: 0.15) : AppColors.warningLight,
          Icons.list_alt_rounded,
          'doctor_questions.types.multiple_choice',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.chipRadius,
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            tr(labelKey),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
