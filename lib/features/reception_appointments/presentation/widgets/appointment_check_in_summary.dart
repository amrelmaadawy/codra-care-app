import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentCheckInSummary extends StatelessWidget {
  final AppointmentEntity appointment;

  const AppointmentCheckInSummary({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _buildRow(
            context,
            'reception_appointments.patient_name'.tr(),
            appointment.patient.name,
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildRow(
            context,
            'reception_appointments.doctor_name'.tr(),
            appointment.doctor.name,
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildRow(
            context,
            'reception_appointments.service_name'.tr(),
            appointment.service?.name ?? '',
          ),
          if (appointment.appointmentTime != null) ...[
            const SizedBox(height: AppSpacing.xs),
            _buildRow(
              context,
              'reception_appointments.appointment_time'.tr(),
              appointment.appointmentTime!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: context.textMutedColor,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: context.textColor,
          ),
        ),
      ],
    );
  }
}
