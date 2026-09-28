import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/reception_queue_item_entity.dart';

class QueueItemHeader extends StatelessWidget {
  final ReceptionQueueItemEntity item;

  const QueueItemHeader({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: context.surfaceVariantColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: context.dividerColor.withValues(alpha: 0.35)),
          ),
          child: Text(
            item.ticketNumber,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: context.textColor,
              letterSpacing: 0.4,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        if (item.isUrgent)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 12, color: AppColors.error),
                const SizedBox(width: 3),
                Text(
                  'reception_queue.priority_urgent'.tr(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.error),
                ),
              ],
            ),
          )
        else if (item.isVip)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 12, color: AppColors.accent),
                const SizedBox(width: 3),
                Text(
                  'reception_queue.priority_vip'.tr(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.accent),
                ),
              ],
            ),
          ),
        const Spacer(),
        _buildStatusBadge(context),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color color = context.primaryColor;
    String label = 'reception_queue.status_waiting'.tr();

    if (item.isWithDoctor) {
      color = AppColors.warning;
      label = 'reception_queue.status_with_doctor'.tr();
    } else if (item.isCompleted) {
      color = AppColors.emerald;
      label = 'reception_queue.status_completed'.tr();
    } else if (item.isCancelled) {
      color = AppColors.error;
      label = 'reception_queue.status_cancelled'.tr();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

