import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_dropdown_sheet.dart';
import '../../domain/entities/booking_doctor_entity.dart';
import '../../domain/entities/booking_form_context_entity.dart';
import '../../domain/entities/booking_service_entity.dart';
import 'walk_in_priority_selector.dart';

class WalkInDoctorServiceStep extends StatelessWidget {
  final BookingFormContextEntity? formContext;
  final BookingDoctorEntity? selectedDoctor;
  final BookingServiceEntity? selectedService;
  final String selectedPriority;
  final String selectedBookingType;
  final ValueChanged<BookingDoctorEntity> onDoctorSelected;
  final ValueChanged<BookingServiceEntity> onServiceSelected;
  final ValueChanged<String> onPriorityChanged;
  final ValueChanged<String> onBookingTypeChanged;

  const WalkInDoctorServiceStep({
    super.key,
    required this.formContext,
    required this.selectedDoctor,
    required this.selectedService,
    required this.selectedPriority,
    required this.selectedBookingType,
    required this.onDoctorSelected,
    required this.onServiceSelected,
    required this.onPriorityChanged,
    required this.onBookingTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final doctors = formContext?.doctors ?? [];
    final services = formContext?.services ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          icon: Icons.person_pin_rounded,
          title: 'reception_booking.doctor_selection_title'.tr(),
        ),
        const SizedBox(height: AppSpacing.xs),
        AppDropdownSheet<BookingDoctorEntity>(
          title: 'reception_booking.select_doctor'.tr(),
          items: doctors,
          selectedItem: selectedDoctor,
          itemLabel: (doc) => '${doc.name} (${doc.specialization})',
          onSelected: onDoctorSelected,
          searchHint: 'reception_booking.choose_doctor_hint'.tr(),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildSectionHeader(
          context,
          icon: Icons.medical_services_rounded,
          title: 'reception_booking.service_selection_title'.tr(),
        ),
        const SizedBox(height: AppSpacing.xs),
        AppDropdownSheet<BookingServiceEntity>(
          title: 'reception_booking.select_service'.tr(),
          items: services,
          selectedItem: selectedService,
          itemLabel: (srv) =>
              '${srv.name} — ${srv.price.toStringAsFixed(0)} ${'reception_booking.currency'.tr()}',
          onSelected: onServiceSelected,
          searchHint: selectedDoctor == null
              ? 'reception_booking.select_doctor_first'.tr()
              : 'reception_booking.choose_service_hint'.tr(),
        ),
        if (selectedService != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _buildServiceSummary(context, selectedService!),
        ],
        const SizedBox(height: AppSpacing.lg),
        _buildSectionHeader(
          context,
          icon: Icons.offline_bolt_rounded,
          title: 'reception_booking.priority_title'.tr(),
        ),
        const SizedBox(height: AppSpacing.xs),
        WalkInPrioritySelector(
          selectedPriority: selectedPriority,
          onPriorityChanged: onPriorityChanged,
        ),
        if (selectedPriority == 'urgent') ...[
          const SizedBox(height: AppSpacing.sm),
          _buildUrgentAlert(context),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: context.primaryColor),
        const SizedBox(width: AppSpacing.xs),
        Text(
          title,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSummary(BuildContext context, BookingServiceEntity srv) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                srv.isPackage ? Icons.all_inclusive : Icons.check_circle_outline,
                size: 18,
                color: context.primaryColor,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                srv.isPackage
                    ? 'reception_booking.package_sessions_count'.tr(args: [
                        (srv.totalSessions ?? 1).toString(),
                      ])
                    : 'reception_booking.standard_consultation'.tr(),
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.textColor,
                ),
              ),
            ],
          ),
          Text(
            '${srv.price.toStringAsFixed(0)} ${'reception_booking.currency'.tr()}',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentAlert(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, size: 16, color: AppColors.error),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              'reception_booking.urgent_walk_in_warning'.tr(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
