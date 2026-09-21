import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class PrescriptionFilterBar extends StatelessWidget {
  final bool? currentFilter;
  final ValueChanged<bool?> onFilterChanged;

  const PrescriptionFilterBar({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          _buildChip(
            context,
            label: 'prescription.filter_all'.tr(),
            isSelected: currentFilter == null,
            dotColor: context.primaryColor,
            onTap: () => onFilterChanged(null),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildChip(
            context,
            label: 'prescription.filter_printed'.tr(),
            isSelected: currentFilter == true,
            dotColor: AppColors.success,
            onTap: () => onFilterChanged(true),
          ),
          const SizedBox(width: AppSpacing.sm),
          _buildChip(
            context,
            label: 'prescription.filter_unprinted'.tr(),
            isSelected: currentFilter == false,
            dotColor: AppColors.warning,
            onTap: () => onFilterChanged(false),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required Color dotColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? context.primaryColor : context.surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? context.primaryColor
                : context.dividerColor.withValues(alpha: 0.35),
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: context.primaryColor.withValues(alpha: 0.28),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? Colors.white : context.textSecondaryColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
