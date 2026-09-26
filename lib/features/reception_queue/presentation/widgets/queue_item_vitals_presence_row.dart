import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/reception_queue_item_entity.dart';

class QueueItemVitalsPresenceRow extends StatelessWidget {
  final ReceptionQueueItemEntity item;
  final bool isPending;
  final String? pendingAction;
  final ValueChanged<bool> onTogglePresence;
  final VoidCallback onOpenVitals;

  const QueueItemVitalsPresenceRow({
    super.key,
    required this.item,
    required this.isPending,
    this.pendingAction,
    required this.onTogglePresence,
    required this.onOpenVitals,
  });

  @override
  Widget build(BuildContext context) {
    final vitals = item.vitalSigns;
    final hasVitals = vitals != null && vitals.hasAny;

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: item.capabilities.canSaveVitals ? onOpenVitals : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: hasVitals
                    ? AppColors.infoLight.withValues(alpha: 0.3)
                    : context.surfaceVariantColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.monitor_heart_outlined,
                    size: 14,
                    color: hasVitals ? AppColors.info : context.textSecondaryColor,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      hasVitals
                          ? '${vitals.bloodPressure ?? ''} ${vitals.temperature != null ? '${vitals.temperature}°C' : ''} ${vitals.bmi != null ? 'BMI: ${vitals.bmi}' : ''}'.trim()
                          : (item.capabilities.canSaveVitals
                              ? 'reception_queue.add_vitals'.tr()
                              : 'reception_queue.no_vitals'.tr()),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: hasVitals ? FontWeight.w600 : FontWeight.w400,
                        color: hasVitals ? AppColors.info : context.textSecondaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _buildPresenceControl(context),
      ],
    );
  }

  Widget _buildPresenceControl(BuildContext context) {
    final canToggle = item.capabilities.canTogglePresence;
    final isPresencePending = isPending && pendingAction == 'presence';

    return InkWell(
      onTap: canToggle && !isPresencePending ? () => onTogglePresence(!item.isPresent) : null,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: item.isPresent
              ? AppColors.success.withValues(alpha: 0.12)
              : context.surfaceVariantColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: item.isPresent ? AppColors.success : context.dividerColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.isPresent ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              size: 14,
              color: item.isPresent ? AppColors.success : context.textSecondaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              item.isPresent
                  ? 'reception_queue.present'.tr()
                  : 'reception_queue.absent'.tr(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: item.isPresent ? AppColors.success : context.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
