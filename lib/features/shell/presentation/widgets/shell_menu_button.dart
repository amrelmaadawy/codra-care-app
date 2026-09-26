import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shell_scope.dart';

class ShellMenuButton extends StatelessWidget {
  final Color? color;

  const ShellMenuButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.minTouchTarget,
      height: AppSizes.minTouchTarget,
      child: IconButton(
        icon: const Icon(AppIcons.menu),
        color: color ?? context.textColor,
        tooltip: 'shell.menu'.tr(),
        onPressed: () {
          final shellScope = AppShellScope.of(context);
          if (shellScope != null) {
            shellScope.openDrawer();
          } else {
            Scaffold.maybeOf(context)?.openDrawer();
          }
        },
      ),
    );
  }
}
