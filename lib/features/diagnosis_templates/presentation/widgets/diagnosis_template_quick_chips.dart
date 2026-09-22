import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../cubit/diagnosis_template_list_state.dart';

class DiagnosisTemplateQuickChips extends StatelessWidget {
  final DiagnosisTemplateFilterChip selected;
  final ValueChanged<DiagnosisTemplateFilterChip> onSelected;

  const DiagnosisTemplateQuickChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final chips = [
      (
        DiagnosisTemplateFilterChip.all,
        'diagnosis_template.filters.all'.tr(),
        Icons.apps_rounded
      ),
      (
        DiagnosisTemplateFilterChip.topUsed,
        'diagnosis_template.filters.top_used'.tr(),
        Icons.trending_up_rounded
      ),
      (
        DiagnosisTemplateFilterChip.hasDiagnosis,
        'diagnosis_template.filters.has_diagnosis'.tr(),
        Icons.medical_information_outlined
      ),
      (
        DiagnosisTemplateFilterChip.hasComplaint,
        'diagnosis_template.filters.has_complaint'.tr(),
        Icons.chat_bubble_outline_rounded
      ),
      (
        DiagnosisTemplateFilterChip.hasNotes,
        'diagnosis_template.filters.has_notes'.tr(),
        Icons.notes_rounded
      ),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final item = chips[index];
          final isSelected = selected == item.$1;

          return FilterChip(
            selected: isSelected,
            showCheckmark: false,
            avatar: Icon(
              item.$3,
              size: 16,
              color: isSelected
                  ? context.primaryColor
                  : context.textSecondaryColor,
            ),
            label: Text(
              item.$2,
              style: AppTypography.caption.copyWith(
                color: isSelected
                    ? context.primaryColor
                    : context.textSecondaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            backgroundColor: context.surfaceColor,
            selectedColor: context.primaryColor.withValues(alpha: 0.12),
            side: BorderSide(
              color: isSelected
                  ? context.primaryColor
                  : context.dividerColor.withValues(alpha: 0.6),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.chipRadius,
            ),
            onSelected: (_) => onSelected(item.$1),
          );
        },
      ),
    );
  }
}
