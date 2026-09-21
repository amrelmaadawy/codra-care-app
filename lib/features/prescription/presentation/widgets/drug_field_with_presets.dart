import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_dropdown_sheet.dart';

class DrugFieldWithPresets extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final List<String> presets;
  final ValueChanged<String> onChanged;
  final IconData? prefixIcon;

  const DrugFieldWithPresets({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.presets,
    required this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          key: ValueKey('${label}_$value'),
          style: AppTypography.bodyMedium.copyWith(
            color: context.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: context.textMutedColor.withValues(alpha: 0.65),
              fontSize: 13,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: context.primaryColor, size: 18)
                : null,
            suffixIcon: presets.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.tune_rounded,
                      size: 18,
                      color: context.primaryColor,
                    ),
                    tooltip: 'common.select'.tr(),
                    splashRadius: 18,
                    onPressed: () async {
                      final selected = await AppDropdownSheet.show<String>(
                        context: context,
                        title: label,
                        items: presets,
                        selectedItem: value,
                        itemLabel: (s) => s,
                        isSearchable: presets.length > 5,
                      );
                      if (selected != null) {
                        onChanged(selected);
                      }
                    },
                  )
                : null,
            filled: true,
            fillColor: context.surfaceColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark
                    ? context.dividerColor.withValues(alpha: 0.3)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark
                    ? context.dividerColor.withValues(alpha: 0.3)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: context.primaryColor, width: 1.4),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
