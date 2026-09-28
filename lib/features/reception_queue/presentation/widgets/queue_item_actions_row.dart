import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/reception_queue_item_entity.dart';

class QueueItemActionsRow extends StatelessWidget {
  final ReceptionQueueItemEntity item;
  final bool isPending;
  final VoidCallback onCallDoctor;
  final VoidCallback onComplete;
  final VoidCallback onCancel;
  final VoidCallback? onOpenPayment;

  const QueueItemActionsRow({
    super.key,
    required this.item,
    required this.isPending,
    required this.onCallDoctor,
    required this.onComplete,
    required this.onCancel,
    this.onOpenPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (item.capabilities.canCancel)
          TextButton(
            onPressed: isPending ? null : onCancel,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error.withValues(alpha: 0.85),
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              'reception_queue.action_cancel'.tr(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        const Spacer(),
        if (item.appointmentId != null && onOpenPayment != null) ...[
          OutlinedButton.icon(
            onPressed: isPending ? null : onOpenPayment,
            icon: const Icon(Icons.payment_rounded, size: 14),
            label: Text(
              'payments.pay'.tr(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.primaryColor,
              backgroundColor: context.primaryColor.withValues(alpha: 0.06),
              side: BorderSide(color: context.primaryColor.withValues(alpha: 0.32)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 6),
        ],
        if (item.capabilities.canCallDoctor)
          ElevatedButton.icon(
            onPressed: isPending ? null : onCallDoctor,
            icon: const Icon(Icons.record_voice_over_rounded, size: 14),
            label: Text(
              'reception_queue.action_call_doctor'.tr(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        if (item.capabilities.canComplete)
          ElevatedButton.icon(
            onPressed: isPending ? null : onComplete,
            icon: const Icon(Icons.done_all_rounded, size: 14),
            label: Text(
              'reception_queue.action_complete'.tr(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emerald,
              foregroundColor: Colors.white,
              elevation: 0,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
      ],
    );
  }
}
