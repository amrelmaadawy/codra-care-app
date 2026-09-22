import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/doctor_question_entity.dart';
import 'doctor_question_action_button.dart';
import 'doctor_question_active_toggle.dart';
import 'doctor_question_options_preview.dart';
import 'doctor_question_type_badge.dart';

class DoctorQuestionCard extends StatelessWidget {
  final DoctorQuestionEntity question;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const DoctorQuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final active = question.isActive;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: active
              ? context.primaryColor.withValues(alpha: 0.25)
              : context.dividerColor.withValues(alpha: 0.4),
          width: active ? 1.2 : 1.0,
        ),
        boxShadow: active ? context.cardShadow : const [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 10),
            Text(
              question.text,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: active ? context.textPrimaryColor : context.textMutedColor,
                height: 1.35,
              ),
            ),
            if (question.hasOptions) ...[
              const SizedBox(height: AppSpacing.xs),
              DoctorQuestionOptionsPreview(options: question.options),
            ],
            const SizedBox(height: AppSpacing.sm),
            Divider(height: 1, color: context.dividerColor.withValues(alpha: 0.45)),
            const SizedBox(height: 8),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        ReorderableDragStartListener(
          index: index,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: context.surfaceVariantColor.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.drag_indicator_rounded,
              color: context.textMutedColor,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: context.dividerColor.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '#${index + 1}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: context.textMutedColor,
            ),
          ),
        ),
        const SizedBox(width: 6),
        DoctorQuestionTypeBadge(type: question.type),
        const SizedBox(width: 6),
        _buildRequiredBadge(context),
        const Spacer(),
        DoctorQuestionActiveToggle(
          isActive: question.isActive,
          onToggle: onToggle,
        ),
      ],
    );
  }

  Widget _buildRequiredBadge(BuildContext context) {
    final isReq = question.isRequired;
    final color = isReq ? AppColors.error : context.textMutedColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: isReq
            ? AppColors.error.withValues(alpha: 0.1)
            : context.surfaceVariantColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isReq
              ? AppColors.error.withValues(alpha: 0.25)
              : context.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        isReq
            ? tr('doctor_questions.badges.required')
            : tr('doctor_questions.badges.optional'),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final active = question.isActive;
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.emerald : context.textMutedColor,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          active
              ? tr('doctor_questions.badges.active')
              : tr('doctor_questions.badges.inactive'),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.emerald : context.textMutedColor,
          ),
        ),
        const Spacer(),
        DoctorQuestionActionButton(
          label: tr('common.edit'),
          icon: Icons.edit_outlined,
          color: context.primaryColor,
          onTap: onEdit,
        ),
        const SizedBox(width: 6),
        DoctorQuestionActionButton(
          label: tr('common.delete'),
          icon: Icons.delete_outline_rounded,
          color: AppColors.error,
          onTap: onDelete,
        ),
      ],
    );
  }
}
