import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class DrugNameField extends StatelessWidget {
  final String initialValue;
  final String itemId;
  final ValueChanged<String> onChanged;

  const DrugNameField({
    super.key,
    required this.initialValue,
    required this.itemId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'prescription.drug_name'.tr(),
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          key: ValueKey('name_$itemId'),
          style: AppTypography.titleSmall.copyWith(
            color: context.textPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: 'prescription.drug_name_hint'.tr(),
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: context.textMutedColor.withValues(alpha: 0.65),
              fontSize: 13,
            ),
            prefixIcon: Icon(
              Icons.medication_rounded,
              color: context.primaryColor,
              size: 20,
            ),
            filled: true,
            fillColor: context.surfaceColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 13),
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
