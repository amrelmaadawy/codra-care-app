import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class QueuePriorityBadge extends StatelessWidget {
  final bool isUrgent;
  final bool isVip;

  const QueuePriorityBadge({
    super.key,
    required this.isUrgent,
    required this.isVip,
  });

  @override
  Widget build(BuildContext context) {
    if (isUrgent) {
      return _buildBadge(
        label: 'doctor_queue.priority_urgent'.tr(),
        color: AppColors.statusUrgent,
        icon: Icons.emergency_rounded,
      );
    }
    if (isVip) {
      return _buildBadge(
        label: 'doctor_queue.priority_vip'.tr(),
        color: AppColors.warning,
        icon: Icons.star_rounded,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildBadge({required String label, required Color color, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.chipRadius,
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class QueueStatusBadge extends StatelessWidget {
  final bool isWithDoctor;
  final bool isCompleted;

  const QueueStatusBadge({
    super.key,
    required this.isWithDoctor,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String text;

    if (isCompleted) {
      color = AppColors.success;
      text = 'doctor_queue.status_completed'.tr();
    } else if (isWithDoctor) {
      color = context.primaryColor;
      text = 'doctor_queue.status_with_doctor'.tr();
    } else {
      color = AppColors.warning;
      text = 'doctor_queue.status_waiting'.tr();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.chipRadius,
        border: Border.all(
          color: color.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class QueueWaitTimeBadge extends StatelessWidget {
  final String timeText;

  const QueueWaitTimeBadge({super.key, required this.timeText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: context.dividerColor.withValues(alpha: 0.25),
        borderRadius: AppRadius.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 11,
            color: context.textMutedColor,
          ),
          const SizedBox(width: 3),
          Text(
            timeText,
            style: AppTypography.labelSmall.copyWith(
              fontSize: 10,
              color: context.textMutedColor,
            ),
          ),
        ],
      ),
    );
  }
}
