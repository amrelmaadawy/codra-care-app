import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/appointment_enums.dart';

class AppointmentStatusChip extends StatelessWidget {
  final AppointmentStatus status;

  const AppointmentStatusChip({super.key, required this.status});

  (Color bg, Color fg) _colors(bool isDark) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return (
          isDark
              ? AppColors.info.withValues(alpha: 0.2)
              : AppColors.infoLight.withValues(alpha: 0.5),
          isDark ? AppColors.infoLight : AppColors.info,
        );
      case AppointmentStatus.inConsultation:
        return (
          isDark
              ? AppColors.warning.withValues(alpha: 0.2)
              : AppColors.warningLight.withValues(alpha: 0.5),
          isDark ? AppColors.warningLight : AppColors.warning,
        );
      case AppointmentStatus.completed:
        return (
          isDark
              ? AppColors.success.withValues(alpha: 0.2)
              : AppColors.successLight.withValues(alpha: 0.5),
          isDark ? AppColors.successLight : AppColors.success,
        );
      case AppointmentStatus.cancelled:
        return (
          isDark
              ? AppColors.error.withValues(alpha: 0.2)
              : AppColors.errorLight.withValues(alpha: 0.5),
          isDark ? AppColors.errorLight : AppColors.error,
        );
      case AppointmentStatus.unknown:
        return (
          isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
          isDark ? AppColors.onSurfaceMutedDark : AppColors.onSurfaceMutedLight,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (bg, fg) = _colors(isDark);
    final label = 'reception_appointments.status_${status.name}'.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
