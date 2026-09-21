import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class ShellNavItem {
  final String route;
  final String labelKey;
  final IconData icon;
  final IconData activeIcon;

  const ShellNavItem({
    required this.route,
    required this.labelKey,
    required this.icon,
    required this.activeIcon,
  });
}

class AppBottomNavBar extends StatelessWidget {
  final List<ShellNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final clampedIndex = currentIndex.clamp(0, items.length - 1);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: Container(
          height: AppSizes.bottomNavHeight + 4,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: context.dividerColor.withValues(alpha: 0.6),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: context.isDarkMode ? 0.35 : 0.08,
                ),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: context.primaryColor.withValues(
                  alpha: context.isDarkMode ? 0.15 : 0.05,
                ),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected = index == clampedIndex;

                return _NavBarItem(
                  item: item,
                  isSelected: isSelected,
                  onTap: () {
                    if (!isSelected) {
                      HapticFeedback.lightImpact();
                      onSelect(index);
                    }
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final ShellNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isSelected ? 5 : 2,
      child: Semantics(
        button: true,
        label: item.labelKey.tr(),
        selected: isSelected,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Center(
            child: AnimatedContainer(
              duration: AppDurations.normal,
              curve: Curves.easeOutCubic,
              height: 48,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          context.primaryColor,
                          AppColors.primaryLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.circular(26),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: context.primaryColor.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 10 : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected ? item.activeIcon : item.icon,
                      size: AppSizes.iconMd + 1,
                      color: isSelected
                          ? context.onPrimaryColor
                          : context.textMutedColor,
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          item.labelKey.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelMedium.copyWith(
                            color: context.onPrimaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
