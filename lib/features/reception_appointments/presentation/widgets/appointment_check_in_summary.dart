import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
        color: context.surfaceVariantColor.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          _buildRow(
            context,
            icon: Icons.person_outline_rounded,
            label: 'reception_appointments.patient_name'.tr(),
            value: appointment.patient.name,
          ),
          Divider(
            height: AppSpacing.md,
            thickness: 0.7,
            color: context.dividerColor.withValues(alpha: 0.4),
          ),
          _buildRow(
            context,
            icon: Icons.badge_outlined,
            label: 'reception_appointments.doctor_name'.tr(),
            value: appointment.doctor.name,
          ),
          Divider(
            height: AppSpacing.md,
            thickness: 0.7,
            color: context.dividerColor.withValues(alpha: 0.4),
          ),
          _buildRow(
            context,
            icon: Icons.medical_services_outlined,
            label: 'reception_appointments.service_name'.tr(),
            value: appointment.service?.name ?? '',
          ),
          if (appointment.appointmentTime != null &&
              appointment.appointmentTime!.isNotEmpty) ...[
            Divider(
              height: AppSpacing.md,
              thickness: 0.7,
              color: context.dividerColor.withValues(alpha: 0.4),
            ),
            _buildRow(
              context,
              icon: Icons.access_time_rounded,
              label: 'reception_appointments.appointment_time'.tr(),
              value: appointment.appointmentTime!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 15, color: context.textMutedColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: context.textMutedColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: context.textColor,
              fontSize: 12.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
