import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'doctor_question_predefined_templates.dart';
import 'doctor_question_type_badge.dart';

class DoctorQuestionTemplateTile extends StatelessWidget {
  final PredefinedQuestionTemplate template;
  final bool isAdded;
  final VoidCallback onAdd;

  const DoctorQuestionTemplateTile({
    super.key,
    required this.template,
    required this.isAdded,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final text = tr(template.textKey);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isAdded
            ? context.surfaceVariantColor.withValues(alpha: 0.3)
            : context.surfaceVariantColor.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isAdded
              ? context.dividerColor.withValues(alpha: 0.25)
              : context.dividerColor.withValues(alpha: 0.45),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 4,
        ),
        title: Text(
          text,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isAdded ? context.textMutedColor : context.textPrimaryColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              DoctorQuestionTypeBadge(type: template.type),
              if (template.isRequired) ...[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  tr('doctor_questions.badges.required'),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ],
            ],
          ),
        ),
        trailing: isAdded
            ? _buildAlreadyAddedBadge()
            : IconButton(
                icon: Icon(
                  Icons.add_circle_rounded,
                  color: context.primaryColor,
                  size: 24,
                ),
                onPressed: onAdd,
              ),
      ),
    );
  }

  Widget _buildAlreadyAddedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.emerald.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.emerald.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded, size: 13, color: AppColors.emerald),
          const SizedBox(width: 4),
          Text(
            tr('doctor_questions.already_added'),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.emerald,
            ),
          ),
        ],
      ),
    );
  }
}
