import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class DrawerSectionHeader extends StatelessWidget {
  final String titleKey;

  const DrawerSectionHeader({super.key, required this.titleKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(
        titleKey.tr().toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: context.textMutedColor.withValues(alpha: 0.75),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          fontSize: 11,
        ),
      ),
    );
  }
}

class DrawerItemTile extends StatelessWidget {
  final IconData icon;
  final String labelKey;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDestructive;

  const DrawerItemTile({
    super.key,
    required this.icon,
    required this.labelKey,
    this.isSelected = false,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isDestructive
        ? AppColors.error
        : (isSelected ? context.primaryColor : context.textColor);

    final tileBgColor = isDestructive
        ? AppColors.error.withValues(alpha: 0.08)
        : (isSelected
            ? context.primaryColor.withValues(alpha: 0.10)
            : Colors.transparent);

    final tileBorder = isSelected
        ? Border.all(
            color: context.primaryColor.withValues(alpha: 0.22),
          )
        : (isDestructive
            ? Border.all(
                color: AppColors.error.withValues(alpha: 0.2),
              )
            : null);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: 3,
      ),
      child: Material(
        color: tileBgColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: tileBorder,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm + 4,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? AppColors.error.withValues(alpha: 0.12)
                        : (isSelected
                            ? context.primaryColor
                            : context.surfaceVariantColor.withValues(
                                alpha: context.isDarkMode ? 0.35 : 0.6,
                              )),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: isDestructive
                        ? AppColors.error
                        : (isSelected
                            ? AppColors.onPrimary
                            : context.textColor.withValues(alpha: 0.75)),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    labelKey.tr(),
                    style: AppTypography.bodyMedium.copyWith(
                      color: effectiveColor,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 4,
                    height: 16,
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
    );
  }
}
