import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../cubits/appointment_form_state.dart';

class BookingSummaryCard extends StatelessWidget {
  final AppointmentFormState state;

  const BookingSummaryCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final patientName = state.isNewPatient
        ? state.newPatient?.fullName ?? ''
        : state.selectedPatient?.fullName ?? '';
    final patientPhone = state.isNewPatient
        ? state.newPatient?.phone ?? ''
        : state.selectedPatient?.phone ?? '';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, color: context.primaryColor, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'reception_booking.summary_title'.tr(),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg),
          _buildRow(
            context,
            'reception_booking.summary_patient'.tr(),
            '$patientName ($patientPhone)',
          ),
          _buildRow(
            context,
            'reception_booking.summary_doctor'.tr(),
            state.selectedDoctor?.name ?? '',
          ),
          _buildRow(
            context,
            'reception_booking.summary_service'.tr(),
            state.selectedService?.name ?? '',
          ),
          _buildRow(
            context,
            'reception_booking.summary_date'.tr(),
            '${state.selectedDate} ${state.selectedSlot != null ? "• ${state.selectedSlot!.label}" : ""}',
          ),
          const Divider(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'reception_booking.summary_total'.tr(),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${state.selectedService?.price.toStringAsFixed(0) ?? 0} ${'reception_appointments.currency'.tr()}',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: context.textMutedColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
