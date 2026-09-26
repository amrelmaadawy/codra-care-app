import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/shell_destination.dart';

class SidebarDestinationTile extends StatelessWidget {
  final ShellDestination destination;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;

  const SidebarDestinationTile({
    super.key,
    required this.destination,
    required this.isSelected,
    this.isCollapsed = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = destination.labelKey.tr();
    final iconData =
        isSelected ? destination.selectedIcon : destination.icon;

    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 3,
        ),
        child: Tooltip(
          message: label,
          preferBelow: false,
          child: Semantics(
            button: true,
            label: label,
            selected: isSelected,
            child: Material(
              color: isSelected
                  ? context.primaryColor.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: SizedBox(
                  height: AppSizes.minTouchTarget,
                  width: AppSizes.minTouchTarget,
                  child: Center(
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                      ),
                      child: Icon(
                        iconData,
                        size: AppSizes.iconMd + 2,
                        color: isSelected
                            ? AppColors.onPrimary
                            : context.textColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final tileBgColor = isSelected
        ? context.primaryColor.withValues(alpha: 0.10)
        : Colors.transparent;

    final tileBorder = isSelected
        ? Border.all(color: context.primaryColor.withValues(alpha: 0.22))
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: 3,
      ),
      child: Semantics(
        button: true,
        label: label,
        selected: isSelected,
        child: Material(
          color: tileBgColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              height: AppSizes.minTouchTarget,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: tileBorder,
              ),
              padding: const EdgeInsetsDirectional.only(
                start: AppSpacing.sm + 4,
                end: AppSpacing.sm + 4,
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.primaryColor
                          : context.surfaceVariantColor.withValues(
                              alpha: context.isDarkMode ? 0.35 : 0.6,
                            ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      iconData,
                      size: AppSizes.iconMd,
                      color: isSelected
                          ? AppColors.onPrimary
                          : context.textColor.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isSelected
                            ? context.primaryColor
                            : context.textColor,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 13.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: context.primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
