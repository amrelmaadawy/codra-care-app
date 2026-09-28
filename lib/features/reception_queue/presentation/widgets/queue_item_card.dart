import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/reception_queue_item_entity.dart';
import 'queue_item_actions_row.dart';
import 'queue_item_header.dart';
import 'queue_item_vitals_presence_row.dart';

class QueueItemCard extends StatelessWidget {
  final ReceptionQueueItemEntity item;
  final bool isPending;
  final String? pendingAction;
  final ValueChanged<bool> onTogglePresence;
  final VoidCallback onCallDoctor;
  final VoidCallback onComplete;
  final VoidCallback onCancel;
  final VoidCallback onOpenVitals;
  final VoidCallback? onOpenPayment;

  const QueueItemCard({
    super.key,
    required this.item,
    required this.isPending,
    this.pendingAction,
    required this.onTogglePresence,
    required this.onCallDoctor,
    required this.onComplete,
    required this.onCancel,
    required this.onOpenVitals,
    this.onOpenPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isUrgent
              ? AppColors.error.withValues(alpha: 0.28)
              : context.dividerColor.withValues(alpha: 0.35),
        ),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QueueItemHeader(item: item),
          const SizedBox(height: AppSpacing.xs),
          _buildPatientInfo(context),
          const SizedBox(height: 3),
          _buildDoctorInfo(context),
          const SizedBox(height: AppSpacing.sm),
          QueueItemVitalsPresenceRow(
            item: item,
            isPending: isPending,
            pendingAction: pendingAction,
            onTogglePresence: onTogglePresence,
            onOpenVitals: onOpenVitals,
          ),
          if (_hasActions) ...[
            const SizedBox(height: AppSpacing.xs),
            Divider(height: 14, thickness: 0.8, color: context.dividerColor.withValues(alpha: 0.25)),
            QueueItemActionsRow(
              item: item,
              isPending: isPending,
              onCallDoctor: onCallDoctor,
              onComplete: onComplete,
              onCancel: onCancel,
              onOpenPayment: onOpenPayment,
            ),
          ],
        ],
      ),
    );
  }

  bool get _hasActions =>
      item.capabilities.canCallDoctor ||
      item.capabilities.canComplete ||
      item.capabilities.canCancel ||
      (item.appointmentId != null && onOpenPayment != null);

  Widget _buildPatientInfo(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.patientName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: context.textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (item.waitMinutes > 0 && !item.isCompleted && !item.isCancelled)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (item.waitMinutes > 30 ? AppColors.warning : context.textSecondaryColor).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 12,
                  color: item.waitMinutes > 30 ? AppColors.warning : context.textSecondaryColor,
                ),
                const SizedBox(width: 3),
                Text(
                  '${item.waitMinutes} ${'reception_queue.min'.tr()}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: item.waitMinutes > 30 ? AppColors.warning : context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDoctorInfo(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.person_outline_rounded, size: 13, color: context.textSecondaryColor),
        const SizedBox(width: 4),
        Text(
          item.doctorName,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: context.textSecondaryColor),
        ),
        if (item.serviceName != null && item.serviceName!.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text('•', style: TextStyle(color: context.dividerColor)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              item.serviceName!,
              style: TextStyle(fontSize: 12, color: context.textSecondaryColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}

