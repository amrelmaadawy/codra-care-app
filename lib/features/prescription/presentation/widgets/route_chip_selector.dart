import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class RouteChipSelector extends StatelessWidget {
  final String selectedRoute;
  final Map<String, String> routeOptions;
  final ValueChanged<String> onSelected;

  const RouteChipSelector({
    super.key,
    required this.selectedRoute,
    required this.routeOptions,
    required this.onSelected,
  });

  IconData _iconForRoute(String key) {
    return switch (key) {
      'oral' => Icons.medication_rounded,
      'topical' => Icons.healing_rounded,
      'iv' => Icons.water_drop_rounded,
      'im' => Icons.vaccines_rounded,
      'inhalation' => Icons.air_rounded,
      'drops' => Icons.opacity_rounded,
      'sublingual' => Icons.medical_services_rounded,
      'rectal' => Icons.medical_information_rounded,
      _ => Icons.circle_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final options = routeOptions.isNotEmpty
        ? routeOptions
        : const {
            'oral': 'فموي',
            'topical': 'موضعي',
            'iv': 'وريدي (IV)',
            'im': 'عضلي (IM)',
            'inhalation': 'استنشاق',
            'drops': 'قطرات',
            'sublingual': 'تحت اللسان',
            'rectal': 'شرجي',
            'other': 'أخرى',
          };

    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final entry = options.entries.elementAt(index);
          final isSelected = selectedRoute == entry.key;

          return InkWell(
            onTap: () => onSelected(entry.key),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconForRoute(entry.key),
                    size: 13,
                    color: isSelected ? Colors.white : context.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    entry.value,
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : context.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
