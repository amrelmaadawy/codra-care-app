import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_enums.dart';
import 'appointment_card_check_in_button.dart';

class AppointmentCardFooter extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback? onCheckIn;
  final bool isCheckingIn;

  const AppointmentCardFooter({
    super.key,
    required this.appointment,
    this.onCheckIn,
    this.isCheckingIn = false,
  });

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return '';
    final parts = time.split(':');
    return parts.length >= 2 ? '${parts[0]}:${parts[1]}' : time;
  }

  @override
  Widget build(BuildContext context) {
    final isTimed = appointment.bookingMode == AppointmentBookingMode.scheduled;
    final timeOrQueueText = appointment.startTime != null
        ? '${_formatTime(appointment.startTime)} - ${_formatTime(appointment.endTime)}'
        : (appointment.queuePosition != null
            ? '${'reception_appointments.queue_num'.tr()} #${appointment.queuePosition}'
            : 'reception_appointments.type_queue'.tr());

    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: context.surfaceVariantColor,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isTimed ? Icons.access_time : Icons.format_list_numbered,
                        size: 13,
                        color: context.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          timeOrQueueText,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: context.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (appointment.isPackage) ...[
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${'reception_appointments.session'.tr()} ${appointment.completedSessions ?? 0}/${appointment.totalSessions ?? 0}',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 10,
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        if (onCheckIn != null) ...[
          AppointmentCardCheckInButton(
            isCheckingIn: isCheckingIn,
            onPressed: onCheckIn!,
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(
          '${appointment.servicePrice.toStringAsFixed(0)} ${'reception_appointments.currency'.tr()}',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: context.primaryColor,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }
}
