import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'quick_chip_row.dart';

class DrugFieldWithChips extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final List<String> chips;
  final ValueChanged<String> onChanged;
  final Widget? prefixIcon;

  const DrugFieldWithChips({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.chips,
    required this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: context.textSecondaryColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          key: ValueKey(value),
          style: AppTypography.bodySmall.copyWith(
            color: context.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.labelSmall.copyWith(
              color: context.textSecondaryColor.withValues(alpha: 0.6),
              fontSize: 11,
            ),
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: isDark ? context.surfaceColor : const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: context.dividerColor.withValues(alpha: 0.4),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: context.dividerColor.withValues(alpha: 0.4),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.emerald,
                width: 1.4,
              ),
            ),
          ),
          onChanged: onChanged,
        ),
        if (chips.isNotEmpty) ...[
          const SizedBox(height: 5),
          QuickChipRow(
            chips: chips,
            selectedValue: value,
            onSelected: onChanged,
          ),
        ],
      ],
    );
  }
}
