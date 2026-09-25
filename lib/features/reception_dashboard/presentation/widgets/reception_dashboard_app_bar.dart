import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/app_shell_scope.dart';

class ReceptionDashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final DateTime? lastUpdated;

  const ReceptionDashboardAppBar({
    super.key,
    this.lastUpdated,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);

  String _formatLastUpdated(BuildContext context, DateTime time) {
    try {
      final langCode =
          Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';
      final formattedTime = DateFormat('HH:mm:ss', langCode).format(time);
      return 'reception_dashboard.last_updated'.tr(args: [formattedTime]);
    } catch (_) {
      final formattedTime = DateFormat('HH:mm:ss').format(time);
      return 'reception_dashboard.last_updated'.tr(args: [formattedTime]);
    }
  }

  String _formatToday(BuildContext context) {
    try {
      final langCode =
          Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';
      return DateFormat('EEEE, d MMMM', langCode).format(DateTime.now());
    } catch (_) {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayFormatted = _formatToday(context);
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
          Container(
            height: 18,
            width: 1,
            color: context.dividerColor,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'reception_dashboard.title'.tr(),
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  lastUpdated != null
                      ? '$todayFormatted • ${_formatLastUpdated(context, lastUpdated!)}'
                      : todayFormatted,
                  style: AppTypography.labelSmall.copyWith(
                    color: context.textMutedColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
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
