import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ExamImageTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onSelected;

  const ExamImageTypeSelector({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  static const _types = [
    {'key': 'scan', 'trKey': 'examination.image_type_scan'},
    {'key': 'lab', 'trKey': 'examination.image_type_lab'},
    {'key': 'document', 'trKey': 'examination.image_type_document'},
    {'key': 'other', 'trKey': 'examination.image_type_other'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: _types.map((t) {
        final isSelected = selectedType == t['key'];
        final label = t['trKey']!.tr();

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelected(t['key']!),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.surfaceVariantDark : const Color(0xFFF8FAFC)),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0)),
                  width: isSelected ? 1.3 : 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    const Icon(Icons.check_rounded, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    label,
                    style: AppTypography.caption.copyWith(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.onSurfaceDark : const Color(0xFF475569)),
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
