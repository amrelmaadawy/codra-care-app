import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class WalkInPatientTabSelector extends StatelessWidget {
  final bool isNewPatient;
  final ValueChanged<bool> onToggle;

  const WalkInPatientTabSelector({
    super.key,
    required this.isNewPatient,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              context,
              isSelected: !isNewPatient,
              icon: Icons.person_search_rounded,
              title: 'reception_booking.tab_existing_patient'.tr(),
              onTap: () => onToggle(false),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildTabButton(
              context,
              isSelected: isNewPatient,
              icon: Icons.person_add_alt_1_rounded,
              title: 'reception_booking.tab_new_patient'.tr(),
              onTap: () => onToggle(true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context, {
    required bool isSelected,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? context.surfaceColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: isSelected ? context.cardShadow : null,
          border: isSelected
              ? Border.all(color: context.primaryColor.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? context.primaryColor : context.textMutedColor,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              title,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? context.primaryColor : context.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
