import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/app_shell_scope.dart';

class DoctorProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DoctorProfileAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      backgroundColor: context.surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      leading: isMobile
          ? IconButton(
              icon: const Icon(AppIcons.menu),
              color: context.textColor,
              onPressed: () => AppShellScope.of(context)?.openDrawer(),
              tooltip: 'shell.menu'.tr(),
            )
          : null,
      titleSpacing: isMobile ? 0 : AppSpacing.md,
      title: Text(
        'profile.title'.tr(),
        style: AppTypography.titleLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: context.textColor,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: context.dividerColor.withValues(alpha: 0.5),
          height: 1,
        ),
      ),
    );
  }
}
