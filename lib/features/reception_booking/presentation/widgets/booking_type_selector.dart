import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/booking_types_and_capabilities.dart';

class BookingTypeSelector extends StatelessWidget {
  final List<BookingTypeEntity> types;
  final String? selectedType;
  final ValueChanged<String> onTypeSelected;

  const BookingTypeSelector({
    super.key,
    required this.types,
    required this.selectedType,
    required this.onTypeSelected,
  });

  IconData _iconForType(String value) {
    switch (value) {
      case 'first_visit':
        return Icons.person_add_alt_1_rounded;
      case 'follow_up':
        return Icons.repeat_rounded;
      case 'routine_check':
        return Icons.verified_rounded;
      case 'urgent':
        return Icons.bolt_rounded;
      default:
        return Icons.bookmark_border_rounded;
    }
  }

  Color _accentColor(BuildContext context, String value) {
    if (value == 'urgent') {
      return AppColors.error;
    }
    return context.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: types.map((t) {
        final isSelected = selectedType == t.value;
        final accent = _accentColor(context, t.value);
        final borderColor = isSelected
            ? accent
            : context.dividerColor.withValues(alpha: 0.6);
        final bgColor = isSelected
            ? accent.withValues(alpha: 0.08)
            : context.surfaceColor;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTypeSelected(t.value),
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: borderColor,
                  width: isSelected ? 1.5 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.12),
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
                    isSelected
                        ? Icons.check_circle_rounded
                        : _iconForType(t.value),
                    size: 16,
                    color: isSelected
                        ? accent
                        : context.textColor.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    t.label,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? accent : context.textColor,
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
