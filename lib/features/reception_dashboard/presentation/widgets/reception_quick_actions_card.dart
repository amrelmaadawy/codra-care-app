import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/app_di.dart';
import '../../../../core/di/permission_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'reception_action_tile.dart';

class ReceptionQuickActionsCard extends StatelessWidget {
  final VoidCallback? onActionCompleted;

  const ReceptionQuickActionsCard({super.key, this.onActionCompleted});

  @override
  Widget build(BuildContext context) {
    final permissions = getIt<PermissionService>();
    final canWalkIn = permissions.canAddWalkIn;
    final canCheckIn = permissions.canCheckIn;

    if (!canWalkIn && !canCheckIn) {
      return const SizedBox.shrink();
    }

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  size: AppSizes.iconSm,
                  color: context.primaryColor,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'reception_dashboard.quick_actions_title'.tr(),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              if (canWalkIn)
                Expanded(
                  child: ReceptionActionTile(
                    title: 'reception_dashboard.action_walk_in_title'.tr(),
                    subtitle: 'reception_dashboard.action_walk_in_subtitle'.tr(),
                    icon: Icons.bolt_rounded,
                    isPrimary: true,
                    semanticsLabel:
                        'reception_dashboard.action_walk_in_semantics'.tr(),
                    onTap: () async {
                      final res = await context.push(AppRoutes.walkIn);
                      if (res == true) {
                        onActionCompleted?.call();
                      }
                    },
                  ),
                ),
              if (canWalkIn && canCheckIn) const SizedBox(width: AppSpacing.sm),
              if (canCheckIn)
                Expanded(
                  child: ReceptionActionTile(
                    title: 'reception_dashboard.action_check_in_title'.tr(),
                    subtitle:
                        'reception_dashboard.action_check_in_subtitle'.tr(),
                    icon: Icons.how_to_reg_rounded,
                    isPrimary: false,
                    semanticsLabel:
                        'reception_dashboard.action_check_in_semantics'.tr(),
                    onTap: () async {
                      final path =
                          '${AppRoutes.appointments}?date=$today&mode=check_in';
                      final res = await context.push(path);
                      if (res == true) {
                        onActionCompleted?.call();
                      }
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
