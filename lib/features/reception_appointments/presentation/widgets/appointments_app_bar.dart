import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/app_shell_scope.dart';

class AppointmentsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasActiveFilter;
  final VoidCallback onFilterPressed;

  const AppointmentsAppBar({
    super.key,
    required this.hasActiveFilter,
    required this.onFilterPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      backgroundColor: context.surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: isMobile
          ? IconButton(
              icon: const Icon(AppIcons.menu),
              color: context.textColor,
              onPressed: () => AppShellScope.of(context)?.openDrawer(),
              tooltip: 'shell.menu'.tr(),
            )
          : null,
      titleSpacing: isMobile ? 0 : AppSpacing.lg,
      title: Row(
        children: [
          Image.asset(
            AppAssets.logoDarkTransparent,
            height: 30,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Text(
              'app_name'.tr(),
              style: AppTypography.titleLarge.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(height: 18, width: 1, color: context.dividerColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'reception_appointments.title'.tr(),
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'reception_appointments.subtitle'.tr(),
                  style: AppTypography.labelSmall.copyWith(
                    color: context.textMutedColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: AppSpacing.md),
          child: Material(
            color: hasActiveFilter
                ? context.primaryColor.withValues(alpha: 0.12)
                : (context.isDarkMode
                    ? context.dividerColor.withValues(alpha: 0.15)
                    : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: InkWell(
              onTap: onFilterPressed,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: hasActiveFilter
                        ? context.primaryColor.withValues(alpha: 0.4)
                        : context.dividerColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 19,
                      color: hasActiveFilter
                          ? context.primaryColor
                          : context.textColor,
                    ),
                    if (hasActiveFilter) ...[
                      const SizedBox(width: 5),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: context.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(AppSizes.borderWidthThin),
        child: Container(
          color: context.dividerColor.withValues(alpha: 0.5),
          height: AppSizes.borderWidthThin,
        ),
      ),
    );
  }
}
