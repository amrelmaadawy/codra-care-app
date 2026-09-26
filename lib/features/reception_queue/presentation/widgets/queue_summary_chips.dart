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
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _buildSegment(
            context: context,
            label: 'reception_queue.summary_all'.tr(),
            count: summary.total,
            statusKey: null,
            accentColor: context.primaryColor,
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildSegment(
            context: context,
            label: 'reception_queue.summary_waiting'.tr(),
            count: summary.waiting,
            statusKey: 'waiting',
            accentColor: AppColors.statusWaiting,
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildSegment(
            context: context,
            label: 'reception_queue.summary_with_doctor'.tr(),
            count: summary.withDoctor,
            statusKey: 'with_doctor',
            accentColor: AppColors.statusInConsultation,
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildSegment(
            context: context,
            label: 'reception_queue.summary_completed'.tr(),
            count: summary.completed,
            statusKey: 'completed',
            accentColor: AppColors.statusCompleted,
          ),
          if (summary.cancelled > 0) ...[
            const SizedBox(width: AppSpacing.xs),
            _buildSegment(
              context: context,
              label: 'reception_queue.summary_cancelled'.tr(),
              count: summary.cancelled,
              statusKey: 'cancelled',
              accentColor: AppColors.statusCancelled,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSegment({
    required BuildContext context,
    required String label,
    required int count,
    required String? statusKey,
    required Color accentColor,
  }) {
    final isSelected = activeStatus == statusKey;

    return InkWell(
      onTap: () => onStatusSelected(isSelected && statusKey != null ? null : statusKey),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.12)
              : context.surfaceVariantColor.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? accentColor
                : context.dividerColor.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? accentColor : context.textPrimaryColor,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected ? accentColor : context.surfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : context.textSecondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
