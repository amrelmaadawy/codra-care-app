import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_enums.dart';
import 'appointment_status_chip.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback? onCancel;

  const AppointmentCard({super.key, required this.appointment, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: AppSpacing.sm),
          _buildDoctorAndService(context),
          const SizedBox(height: AppSpacing.sm),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.patient.name,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (appointment.patient.patientCode != null)
                Text(
                  appointment.patient.patientCode!,
                  style: AppTypography.bodySmall.copyWith(
                    color: context.textMutedColor,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
        AppointmentStatusChip(status: appointment.status),
        if (appointment.canCancel && onCancel != null) ...[
          const SizedBox(width: AppSpacing.xs),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              size: 20,
              color: context.textMutedColor,
            ),
            padding: EdgeInsets.zero,
            onSelected: (val) {
              if (val == 'cancel') onCancel!();
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'cancel',
                child: Row(
                  children: [
                    const Icon(
                      Icons.cancel_outlined,
                      size: 18,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'reception_appointments.cancel_appointment'.tr(),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDoctorAndService(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.medical_services_outlined,
          size: 16,
          color: context.textMutedColor,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            '${appointment.doctor.name} • ${appointment.service?.name ?? ''}',
            style: AppTypography.bodySmall.copyWith(
              color: context.textMutedColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isTimed = appointment.bookingMode == AppointmentBookingMode.scheduled;
    final timeOrQueueText = appointment.startTime != null
        ? '${appointment.startTime ?? ''} - ${appointment.endTime ?? ''}'
        : (appointment.queuePosition != null
              ? '${'reception_appointments.queue_num'.tr()} #${appointment.queuePosition}'
              : 'reception_appointments.type_queue'.tr());

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
              Text(
                timeOrQueueText,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: context.textColor,
                ),
              ),
            ],
          ),
        ),
        if (appointment.isPackage) ...[
          const SizedBox(width: AppSpacing.xs),
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
        const Spacer(),
        Text(
          '${appointment.servicePrice.toStringAsFixed(0)} ${'reception_appointments.currency'.tr()}',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: context.primaryColor,
          ),
        ),
      ],
    );
  }
}
