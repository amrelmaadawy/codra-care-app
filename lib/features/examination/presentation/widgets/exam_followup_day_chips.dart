import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ExamFollowupDayChips extends StatelessWidget {
  final int? selectedDays;
  final ValueChanged<int?> onSelected;

  const ExamFollowupDayChips({
    super.key,
    required this.selectedDays,
    required this.onSelected,
  });

  static const _quickOptions = [3, 7, 10, 14, 21, 30];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: _quickOptions.map((opt) => _buildChip(context, opt, isDark)).toList(),
    );
  }

  Widget _buildChip(BuildContext context, int opt, bool isDark) {
    final isSelected = selectedDays == opt;
    final label = _formatDayLabel(context, opt);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelected(isSelected ? null : opt),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.surfaceVariantDark : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0)),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.onSurfaceDark : const Color(0xFF334155)),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDayLabel(BuildContext context, int days) {
    final isAr = context.locale.languageCode == 'ar';
    if (isAr) {
      if (days <= 10) return '$days أيام';
      return '$days يوم';
    }
    return days == 1 ? '1 Day' : '$days Days';
  }
}
