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
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: hasVitals
                    ? context.primaryColor.withValues(alpha: 0.07)
                    : context.surfaceVariantColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasVitals
                      ? context.primaryColor.withValues(alpha: 0.22)
                      : context.dividerColor.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    hasVitals ? Icons.monitor_heart_outlined : Icons.add_circle_outline_rounded,
                    size: 14,
                    color: context.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      hasVitals
                          ? '${vitals.bloodPressure ?? ''} ${vitals.temperature != null ? '${vitals.temperature}°C' : ''} ${vitals.bmi != null ? 'BMI: ${vitals.bmi}' : ''}'.trim()
                          : (item.capabilities.canSaveVitals
                              ? 'reception_queue.add_vitals'.tr()
                              : 'reception_queue.no_vitals'.tr()),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: hasVitals ? FontWeight.w600 : FontWeight.w500,
                        color: hasVitals ? context.primaryColor : context.textColor.withValues(alpha: 0.85),
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
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: item.isPresent
              ? AppColors.emerald.withValues(alpha: 0.08)
              : context.surfaceVariantColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: item.isPresent
                ? AppColors.emerald.withValues(alpha: 0.3)
                : context.dividerColor.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.isPresent ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              size: 14,
              color: item.isPresent ? AppColors.emerald : context.textSecondaryColor,
            ),
            const SizedBox(width: 5),
            Text(
              item.isPresent
                  ? 'reception_queue.present'.tr()
                  : 'reception_queue.absent'.tr(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: item.isPresent ? FontWeight.w700 : FontWeight.w500,
                color: item.isPresent ? AppColors.emeraldDark : context.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
