import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/doctor_question_entity.dart';

class DoctorQuestionTypeSelector extends StatelessWidget {
  final DoctorQuestionType selectedType;
  final ValueChanged<DoctorQuestionType> onTypeChanged;

  const DoctorQuestionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('doctor_questions.fields.question_type'),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: context.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.surfaceVariantColor.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.dividerColor.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              _buildTab(
                context,
                type: DoctorQuestionType.text,
                label: tr('doctor_questions.types.text'),
                icon: Icons.text_fields_rounded,
              ),
              const SizedBox(width: 4),
              _buildTab(
                context,
                type: DoctorQuestionType.yesNo,
                label: tr('doctor_questions.types.yes_no'),
                icon: Icons.check_circle_outline_rounded,
              ),
              const SizedBox(width: 4),
              _buildTab(
                context,
                type: DoctorQuestionType.multipleChoice,
                label: tr('doctor_questions.types.multiple_choice'),
                icon: Icons.list_alt_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required DoctorQuestionType type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = selectedType == type;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTypeChanged(type),
          borderRadius: BorderRadius.circular(9),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.surfaceColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
              border: isSelected
                  ? Border.all(
                      color: context.primaryColor.withValues(alpha: 0.25),
                      width: 1.2,
                    )
                  : Border.all(color: Colors.transparent),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: isSelected ? context.primaryColor : context.textMutedColor,
                ),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? context.primaryColor : context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
