import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/reception_queue_item_entity.dart';
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
              ? AppColors.error.withValues(alpha: 0.4)
              : context.dividerColor.withValues(alpha: 0.7),
        ),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QueueItemHeader(item: item),
          const SizedBox(height: AppSpacing.xs),
          _buildPatientInfo(context),
          const SizedBox(height: AppSpacing.xs),
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
            const SizedBox(height: AppSpacing.sm),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.xs),
            _buildActionButtons(context),
          ],
        ],
      ),
    );
  }

  bool get _hasActions =>
      item.capabilities.canCallDoctor ||
      item.capabilities.canComplete ||
      item.capabilities.canCancel ||
      item.capabilities.canSaveVitals;

  Widget _buildPatientInfo(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.patientName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (item.waitMinutes > 0 && !item.isCompleted && !item.isCancelled)
          Row(
            children: [
              Icon(
                Icons.hourglass_empty_rounded,
                size: 13,
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
      ],
    );
  }

  Widget _buildDoctorInfo(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.person_outline_rounded, size: 14, color: context.textSecondaryColor),
        const SizedBox(width: 4),
        Text(
          item.doctorName,
          style: TextStyle(fontSize: 12, color: context.textSecondaryColor),
        ),
        if (item.serviceName != null && item.serviceName!.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text('•', style: TextStyle(color: context.textSecondaryColor)),
          const SizedBox(width: 6),
          Text(
            item.serviceName!,
            style: TextStyle(fontSize: 12, color: context.textSecondaryColor),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (item.capabilities.canCancel)
          TextButton(
            onPressed: isPending ? null : onCancel,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              'reception_queue.action_cancel'.tr(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        const Spacer(),
        if (item.capabilities.canCallDoctor)
          ElevatedButton.icon(
            onPressed: isPending ? null : onCallDoctor,
            icon: const Icon(Icons.record_voice_over_rounded, size: 14),
            label: Text(
              'reception_queue.action_call_doctor'.tr(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        if (item.capabilities.canComplete)
          ElevatedButton.icon(
            onPressed: isPending ? null : onComplete,
            icon: const Icon(Icons.done_all_rounded, size: 14),
            label: Text(
              'reception_queue.action_complete'.tr(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emerald,
              foregroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
      ],
    );
  }
}
