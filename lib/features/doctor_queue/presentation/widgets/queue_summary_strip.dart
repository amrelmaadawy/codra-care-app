import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/queue_summary_entity.dart';
import '../cubit/doctor_queue_state.dart';

class QueueSummaryStrip extends StatelessWidget {
  final QueueSummaryEntity summary;
  final QueueFilter selectedFilter;
  final ValueChanged<QueueFilter> onFilterSelected;

  const QueueSummaryStrip({
    super.key,
    required this.summary,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  Widget _buildSummaryCard(
    BuildContext context, {
    required String titleKey,
    required int count,
    required Color color,
    required IconData icon,
    required QueueFilter filter,
  }) {
    final isSelected = selectedFilter == filter;

    return Expanded(
      child: Material(
        color: isSelected ? color.withValues(alpha: 0.08) : context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        child: InkWell(
          onTap: () => onFilterSelected(filter),
          borderRadius: AppRadius.cardRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: AppRadius.cardRadius,
              border: Border.all(
                color: isSelected ? color : color.withValues(alpha: 0.2),
                width: isSelected ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? color.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.03),
                  blurRadius: isSelected ? 8 : 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 14, color: color),
                    const SizedBox(width: 4),
                    Text(
                      '$count',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  titleKey.tr(),
                  style: AppTypography.labelXSmall.copyWith(
                    color: isSelected ? color : context.textMutedColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildSummaryCard(
          context,
          titleKey: 'doctor_queue.waiting_count',
          count: summary.waitingCount,
          color: AppColors.warning,
          icon: Icons.hourglass_top_rounded,
          filter: QueueFilter.waiting,
        ),
        const SizedBox(width: AppSpacing.xs),
        _buildSummaryCard(
          context,
          titleKey: 'doctor_queue.with_doctor_count',
          count: summary.withDoctorCount,
          color: context.primaryColor,
          icon: Icons.medical_services_outlined,
          filter: QueueFilter.withDoctor,
        ),
        const SizedBox(width: AppSpacing.xs),
        _buildSummaryCard(
          context,
          titleKey: 'doctor_queue.completed_today',
          count: summary.completedToday,
          color: AppColors.success,
          icon: Icons.check_circle_outline_rounded,
          filter: QueueFilter.completed,
        ),
        const SizedBox(width: AppSpacing.xs),
        _buildSummaryCard(
          context,
          titleKey: 'doctor_queue.urgent_count',
          count: summary.urgentCount,
          color: summary.urgentCount > 0 ? AppColors.statusUrgent : context.textMutedColor,
          icon: Icons.emergency_rounded,
          filter: QueueFilter.urgent,
        ),
      ],
    );
  }
}
