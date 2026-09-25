import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  final VoidCallback onRefresh;

  const ReceptionDashboardAppBar({
    super.key,
    this.lastUpdated,
    required this.onRefresh,
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
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'reception_dashboard.title'.tr(),
            style: AppTypography.titleMedium.copyWith(
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
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
          child: SizedBox(
            width: AppSizes.minTouchTarget,
            height: AppSizes.minTouchTarget,
            child: IconButton(
              icon: const Icon(AppIcons.refresh, size: AppSizes.iconMd),
              color: context.textColor,
              onPressed: onRefresh,
              tooltip: 'common.refresh'.tr(),
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
