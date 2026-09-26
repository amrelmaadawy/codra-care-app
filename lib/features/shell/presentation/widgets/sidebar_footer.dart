import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'shell_logout_dialog.dart';

class SidebarFooter extends StatelessWidget {
  final bool isCollapsed;
  final bool canToggleCollapse;
  final VoidCallback? onToggleCollapse;

  const SidebarFooter({
    super.key,
    this.isCollapsed = false,
    this.canToggleCollapse = false,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    if (isCollapsed) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.dividerColor.withValues(alpha: 0.5),
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canToggleCollapse && onToggleCollapse != null)
              Tooltip(
                message: 'shell.expand'.tr(),
                preferBelow: false,
                child: SizedBox(
                  width: AppSizes.minTouchTarget,
                  height: AppSizes.minTouchTarget,
                  child: IconButton(
                    icon: const Icon(AppIcons.sidebarExpand),
                    color: context.textColor.withValues(alpha: 0.7),
                    onPressed: onToggleCollapse,
                  ),
                ),
              ),
            Tooltip(
              message: 'auth.logout'.tr(),
              preferBelow: false,
              child: SizedBox(
                width: AppSizes.minTouchTarget,
                height: AppSizes.minTouchTarget,
                child: IconButton(
                  icon: const Icon(AppIcons.logout),
                  color: AppColors.error,
                  onPressed: () => ShellLogoutDialog.show(context),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(
          top: BorderSide(
            color: context.dividerColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        MediaQuery.paddingOf(context).bottom + AppSpacing.xs,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canToggleCollapse && onToggleCollapse != null) ...[
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: InkWell(
                onTap: onToggleCollapse,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: SizedBox(
                  height: AppSizes.minTouchTarget,
                  child: Row(
                    children: [
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        AppIcons.sidebarCollapse,
                        size: AppSizes.iconMd,
                        color: context.textColor.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'shell.collapse'.tr(),
                        style: AppTypography.bodySmall.copyWith(
                          color: context.textColor.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          Material(
            color: AppColors.error.withValues(alpha: isDark ? 0.12 : 0.07),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: InkWell(
              onTap: () => ShellLogoutDialog.show(context),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                height: AppSizes.minTouchTarget,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.22),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      AppIcons.logout,
                      size: AppSizes.iconSm + 2,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'auth.logout'.tr(),
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
