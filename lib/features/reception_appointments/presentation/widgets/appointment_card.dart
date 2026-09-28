import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/appointment_entity.dart';
import 'appointment_card_footer.dart';
import 'appointment_status_chip.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback? onCancel;
  final VoidCallback? onCheckIn;
  final bool isCheckingIn;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onCheckIn,
    this.isCheckingIn = false,
  });

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
          AppointmentCardFooter(
            appointment: appointment,
            onCheckIn: onCheckIn,
            isCheckingIn: isCheckingIn,
          ),
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
            itemBuilder: (_) => [
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
}
