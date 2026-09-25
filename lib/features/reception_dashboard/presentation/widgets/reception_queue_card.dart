import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/reception_queue_item_entity.dart';
import 'reception_status_badge.dart';

class ReceptionQueueCard extends StatelessWidget {
  final ReceptionQueueItemEntity item;

  const ReceptionQueueCard({super.key, required this.item});

  Color _getStatusColor() {
    return switch (item.status.toLowerCase()) {
      'with_doctor' => AppColors.statusInConsultation,
      _ => AppColors.statusWaiting,
    };
  }

  String _getStatusLabel() {
    return switch (item.status.toLowerCase()) {
      'with_doctor' => 'reception_dashboard.status_with_doctor'.tr(),
      _ => 'reception_dashboard.status_waiting'.tr(),
    };
  }

  Color _getPriorityColor() {
    return switch (item.priority.toLowerCase()) {
      'urgent' => AppColors.statusUrgent,
      'vip' => AppColors.statusConfirmed,
      _ => AppColors.primaryLight,
    };
  }

  String _getPriorityLabel() {
    return switch (item.priority.toLowerCase()) {
      'urgent' => 'reception_dashboard.priority_urgent'.tr(),
      'vip' => 'reception_dashboard.priority_vip'.tr(),
      _ => 'reception_dashboard.priority_normal'.tr(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final priorityColor = _getPriorityColor();

    return Semantics(
      label:
          '${item.patientName}, ${_getStatusLabel()}, ${_getPriorityLabel()}, ${item.doctorName}',
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(
            color: item.priority.toLowerCase() == 'urgent'
                ? AppColors.statusUrgent.withValues(alpha: 0.5)
                : context.dividerColor.withValues(alpha: 0.6),
            width: item.priority.toLowerCase() == 'urgent'
                ? AppSizes.borderWidthMedium
                : 1.0,
          ),
          boxShadow: context.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    item.ticketNumber,
                    style: AppTypography.labelLarge.copyWith(
                      color: context.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.patientName,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                ReceptionStatusBadge(
                  label: _getPriorityLabel(),
                  color: priorityColor,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  AppIcons.profile,
                  size: AppSizes.iconSm,
                  color: context.textMutedColor,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    item.doctorName,
                    style: AppTypography.bodySmall.copyWith(
                      color: context.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.serviceName != null &&
                    item.serviceName!.trim().isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      item.serviceName!.trim(),
                      style: AppTypography.bodySmall.copyWith(
                        color: context.textMutedColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AppIcons.clock,
                        size: AppSizes.iconSm,
                        color: context.textMutedColor,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'reception_dashboard.wait_minutes'.tr(
                            args: [item.waitMinutes.toString()],
                          ),
                          style: AppTypography.labelSmall.copyWith(
                            color: context.textMutedColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ReceptionStatusBadge(
                  label: _getStatusLabel(),
                  color: statusColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
