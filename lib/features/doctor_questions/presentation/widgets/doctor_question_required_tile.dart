import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_extensions.dart';

class DoctorQuestionRequiredTile extends StatelessWidget {
  final bool isRequired;
  final ValueChanged<bool> onChanged;

  const DoctorQuestionRequiredTile({
    super.key,
    required this.isRequired,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!isRequired),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isRequired
                ? AppColors.error.withValues(alpha: 0.05)
                : context.surfaceVariantColor.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isRequired
                  ? AppColors.error.withValues(alpha: 0.25)
                  : context.dividerColor.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isRequired
                      ? AppColors.error.withValues(alpha: 0.12)
                      : context.dividerColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isRequired ? Icons.priority_high_rounded : Icons.check_circle_outline_rounded,
                  size: 18,
                  color: isRequired ? AppColors.error : context.textMutedColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('doctor_questions.fields.is_required'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isRequired ? context.textPrimaryColor : context.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isRequired
                          ? tr('doctor_questions.badges.required')
                          : tr('doctor_questions.badges.optional'),
                      style: TextStyle(
                        fontSize: 11,
                        color: isRequired ? AppColors.error : context.textMutedColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildSwitch(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 24,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isRequired
            ? context.primaryColor
            : context.dividerColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: isRequired
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
