import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/services/navigation_badge_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class SidebarBadgeIndicator extends StatelessWidget {
  final String destinationId;
  final bool isCollapsed;

  const SidebarBadgeIndicator({
    super.key,
    required this.destinationId,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!GetIt.I.isRegistered<NavigationBadgeService>()) {
      return const SizedBox.shrink();
    }

    final badgeService = GetIt.I<NavigationBadgeService>();
    return ValueListenableBuilder<int>(
      valueListenable: badgeService.getNotifier(destinationId),
      builder: (context, count, _) {
        if (count <= 0) return const SizedBox.shrink();

        final displayText = count > 99 ? '99+' : '$count';

        if (isCollapsed) {
          return PositionedDirectional(
            top: 4,
            end: 4,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xxs),
              decoration: BoxDecoration(
                color: context.errorColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
            ),
          );
        }

        return Container(
          margin: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: context.errorColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: context.errorColor.withValues(alpha: 0.3),
              width: 0.8,
            ),
          ),
          child: Text(
            displayText,
            style: AppTypography.caption.copyWith(
              color: context.errorColor,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        );
      },
    );
  }
}
