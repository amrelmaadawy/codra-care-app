import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'bottom_nav_bar.dart';

class AppNavRail extends StatelessWidget {
  final List<ShellNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback? onLogout;

  const AppNavRail({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelect,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(
          right: BorderSide(
            color: context.dividerColor,
          ),
        ),
      ),
      child: NavigationRail(
        selectedIndex: currentIndex.clamp(0, items.length - 1),
        onDestinationSelected: onSelect,
        backgroundColor: context.surfaceColor,
        indicatorColor: context.primaryColor.withValues(alpha: 0.15),
        labelType: NavigationRailLabelType.all,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Icon(
            AppIcons.clinic,
            size: AppSizes.iconXl,
            color: context.primaryColor,
          ),
        ),
        trailing: onLogout != null
            ? Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: IconButton(
                      icon: const Icon(AppIcons.logout),
                      color: context.textMutedColor,
                      tooltip: 'auth.logout'.tr(),
                      onPressed: onLogout,
                    ),
                  ),
                ),
              )
            : null,
        destinations: items.map((item) {
          return NavigationRailDestination(
            icon: Icon(item.icon, size: AppSizes.iconLg),
            selectedIcon: Icon(
              item.activeIcon,
              size: AppSizes.iconLg,
              color: context.primaryColor,
            ),
            label: Text(item.labelKey.tr()),
          );
        }).toList(),
      ),
    );
  }
}
