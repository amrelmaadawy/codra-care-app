import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class DoctorQuestionOptionsBuilder extends StatelessWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  const DoctorQuestionOptionsBuilder({
    super.key,
    required this.controllers,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr('doctor_questions.fields.options'),
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: context.textPrimaryColor,
              ),
            ),
            TextButton.icon(
              onPressed: onAdd,
              icon: Icon(Icons.add_circle_outline_rounded,
                  size: 16, color: context.primaryColor),
              label: Text(
                tr('doctor_questions.fields.add_option'),
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ...controllers.asMap().entries.map((entry) {
          final idx = entry.key;
          final ctrl = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: ctrl,
                    decoration: InputDecoration(
                      hintText: '${tr('doctor_questions.fields.option_hint')} ${idx + 1}',
                      filled: true,
                      fillColor: context.surfaceVariantColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: AppRadius.cardRadius,
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return tr('doctor_questions.validation.option_empty');
                      }
                      return null;
                    },
                  ),
                ),
                if (controllers.length > 2) ...[
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                    onPressed: () => onRemove(idx),
                    tooltip: tr('common.delete'),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}
