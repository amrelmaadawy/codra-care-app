import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/queue_summary_entity.dart';

class QueueSummaryChips extends StatelessWidget {
  final QueueSummaryEntity summary;
  final String? activeStatus;
  final ValueChanged<String?> onStatusSelected;

  const QueueSummaryChips({
    super.key,
    required this.summary,
    required this.activeStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _buildChip(
            context: context,
            label: 'reception_queue.summary_all'.tr(),
            count: summary.total,
            statusKey: null,
            baseColor: context.primaryColor,
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildChip(
            context: context,
            label: 'reception_queue.summary_waiting'.tr(),
            count: summary.waiting,
            statusKey: 'waiting',
            baseColor: AppColors.statusWaiting,
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildChip(
            context: context,
            label: 'reception_queue.summary_with_doctor'.tr(),
            count: summary.withDoctor,
            statusKey: 'with_doctor',
            baseColor: AppColors.statusInConsultation,
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildChip(
            context: context,
            label: 'reception_queue.summary_completed'.tr(),
            count: summary.completed,
            statusKey: 'completed',
            baseColor: AppColors.statusCompleted,
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildChip(
            context: context,
            label: 'reception_queue.summary_cancelled'.tr(),
            count: summary.cancelled,
            statusKey: 'cancelled',
            baseColor: AppColors.statusCancelled,
          ),
          if (summary.avgWaitMinutes > 0) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: context.surfaceVariantColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: context.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${summary.avgWaitMinutes} ${'reception_queue.min'.tr()}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required int count,
    required String? statusKey,
    required Color baseColor,
  }) {
    final isSelected = activeStatus == statusKey;

    return InkWell(
      onTap: () => onStatusSelected(isSelected && statusKey != null ? null : statusKey),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? baseColor.withValues(alpha: 0.15) : context.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? baseColor : context.dividerColor.withValues(alpha: 0.6),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? baseColor : context.textPrimaryColor,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? baseColor : baseColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : baseColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
