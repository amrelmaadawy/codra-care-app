import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/app_di.dart';
import '../../../../core/di/permission_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

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
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on, size: 20, color: context.primaryColor),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'reception_dashboard.quick_actions_title'.tr(),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              if (canWalkIn)
                Expanded(
                  child: Semantics(
                    button: true,
                    label: 'reception_dashboard.action_walk_in'.tr(),
                    child: SizedBox(
                      height: AppSizes.minTouchTarget,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.bolt, size: 20),
                        label: Text(
                          'reception_dashboard.action_walk_in'.tr(),
                          style: AppTypography.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                        onPressed: () async {
                          final res = await context.push(AppRoutes.walkIn);
                          if (res == true) {
                            onActionCompleted?.call();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              if (canWalkIn && canCheckIn) const SizedBox(width: AppSpacing.md),
              if (canCheckIn)
                Expanded(
                  child: Semantics(
                    button: true,
                    label: 'reception_dashboard.action_check_in'.tr(),
                    child: SizedBox(
                      height: AppSizes.minTouchTarget,
                      child: OutlinedButton.icon(
                        icon: const Icon(
                          Icons.how_to_reg_outlined,
                          size: 20,
                          color: AppColors.emerald,
                        ),
                        label: Text(
                          'reception_dashboard.action_check_in'.tr(),
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.emerald,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.emerald),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                        onPressed: () async {
                          final path =
                              '${AppRoutes.appointments}?date=$today&mode=check_in';
                          final res = await context.push(path);
                          if (res == true) {
                            onActionCompleted?.call();
                          }
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
