import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class QuickChipRow extends StatelessWidget {
  final List<String> chips;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  const QuickChipRow({
    super.key,
    required this.chips,
    this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final chip = chips[index];
          final isSelected = selectedValue == chip;

          return InkWell(
            onTap: () => onSelected(chip),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.emerald
                    : (isDark ? context.surfaceColor : const Color(0xFFF8FAFC)),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.emerald
                      : context.dividerColor.withValues(alpha: 0.35),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.emerald.withValues(alpha: 0.28),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                chip,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : context.textSecondaryColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
