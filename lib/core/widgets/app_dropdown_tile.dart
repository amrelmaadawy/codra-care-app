import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import '../theme/theme_extensions.dart';

class AppDropdownTile<T> extends StatelessWidget {
  final T item;
  final bool isSelected;
  final String label;
  final String? subtitle;
  final Widget? leading;
  final ValueChanged<T> onSelected;

  const AppDropdownTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.label,
    this.subtitle,
    this.leading,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final initial = label.isNotEmpty ? label.characters.first : '?';

    return Material(
      color: isSelected ? context.primaryColor.withValues(alpha: 0.08) : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onSelected(item),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? context.primaryColor.withValues(alpha: 0.35)
                  : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              if (leading != null)
                leading!
              else
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.primaryColor
                        : context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initial,
                    style: TextStyle(
                      color: isSelected ? Colors.white : context.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isSelected ? context.primaryColor : context.textPrimaryColor,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.bodySmall.copyWith(
                          color: context.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: context.primaryColor,
                  size: 21,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
