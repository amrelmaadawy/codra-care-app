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

    final typeLabel = state.formContext?.bookingTypes
            .where((t) => t.value == state.selectedBookingType)
            .firstOrNull
            ?.label ??
        state.selectedBookingType;

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.6)),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.md),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  color: context.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'reception_booking.summary_title'.tr(),
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.primaryColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    border: Border.all(
                      color: context.primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    typeLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: context.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _buildRow(
                  context,
                  icon: Icons.person_outline_rounded,
                  label: 'reception_booking.summary_patient'.tr(),
                  value: patientName,
                  subtitle: patientPhone.isNotEmpty ? patientPhone : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildRow(
                  context,
                  icon: Icons.person_pin_rounded,
                  label: 'reception_booking.summary_doctor'.tr(),
                  value: state.selectedDoctor?.name ?? '',
                  subtitle: state.selectedDoctor?.specialization,
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildRow(
                  context,
                  icon: Icons.medical_services_outlined,
                  label: 'reception_booking.summary_service'.tr(),
                  value: state.selectedService?.name ?? '',
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildRow(
                  context,
                  icon: Icons.event_available_rounded,
                  label: 'reception_booking.summary_date'.tr(),
                  value: state.selectedDate ?? '',
                  subtitle: state.selectedSlot?.label,
                ),
                const Divider(height: AppSpacing.lg),
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
                      '${state.selectedService?.price.toStringAsFixed(0) ?? 0} ${'reception_booking.currency'.tr()}',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: context.textMutedColor),
        const SizedBox(width: AppSpacing.xs),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: context.textMutedColor,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null && subtitle.trim().isNotEmpty)
                Text(
                  subtitle.trim(),
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: context.textMutedColor,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
