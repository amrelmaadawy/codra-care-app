import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class InlineGenderSelector extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  const InlineGenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
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
            child: _genderOption(
              context,
              value: 'male',
              label: 'reception_booking.gender_male'.tr(),
              icon: Icons.male_rounded,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _genderOption(
              context,
              value: 'female',
              label: 'reception_booking.gender_female'.tr(),
              icon: Icons.female_rounded,
              color: Colors.pinkAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderOption(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = selectedGender == value;
    return InkWell(
      onTap: () => onGenderChanged(value),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? context.surfaceColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: isSelected ? context.cardShadow : null,
          border: isSelected ? Border.all(color: color.withValues(alpha: 0.4)) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? color : context.textMutedColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? context.textColor : context.textMutedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
