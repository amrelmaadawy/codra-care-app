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
            color: context.primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            item.ticketNumber,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: context.primaryColor,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        if (item.isUrgent)
          _buildBadge(
            label: 'reception_queue.priority_urgent'.tr(),
            color: AppColors.statusUrgent,
          )
        else if (item.isVip)
          _buildBadge(
            label: 'reception_queue.priority_vip'.tr(),
            color: AppColors.accent,
          ),
        const Spacer(),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color color = AppColors.statusWaiting;
    String label = 'reception_queue.status_waiting'.tr();

    if (item.isWithDoctor) {
      color = AppColors.statusInConsultation;
      label = 'reception_queue.status_with_doctor'.tr();
    } else if (item.isCompleted) {
      color = AppColors.statusCompleted;
      label = 'reception_queue.status_completed'.tr();
    } else if (item.isCancelled) {
      color = AppColors.statusCancelled;
      label = 'reception_queue.status_cancelled'.tr();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBadge({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
