import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class DoctorQuestionFormHeader extends StatelessWidget {
  final bool isEdit;
  final VoidCallback onClose;

  const DoctorQuestionFormHeader({
    super.key,
    required this.isEdit,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: context.dividerColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                tr(isEdit ? 'doctor_questions.edit_title' : 'doctor_questions.add_title'),
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimaryColor,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close_rounded, size: 20, color: context.textMutedColor),
              onPressed: onClose,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ],
    );
  }
}
