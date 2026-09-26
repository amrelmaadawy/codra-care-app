import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_dropdown.dart';
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
        AppDropdown<BookingDoctorEntity>(
          value: selectedDoctor,
          items: doctors,
          itemLabel: (doc) => '${doc.name} (${doc.specialization})',
          hintText: 'reception_booking.choose_doctor_hint'.tr(),
          sheetTitle: 'reception_booking.select_doctor'.tr(),
          searchHint: 'reception_booking.choose_doctor_hint'.tr(),
          prefixIcon: Icons.person_pin_rounded,
          onChanged: onDoctorSelected,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildSectionHeader(
          context,
          icon: Icons.medical_services_rounded,
          title: 'reception_booking.service_selection_title'.tr(),
        ),
        const SizedBox(height: AppSpacing.xs),
        AppDropdown<BookingServiceEntity>(
          value: selectedService,
          items: services,
          enabled: selectedDoctor != null && services.isNotEmpty,
          itemLabel: (srv) =>
              '${srv.name} — ${srv.price.toStringAsFixed(0)} ${'reception_booking.currency'.tr()}',
          hintText: selectedDoctor == null
              ? 'reception_booking.select_doctor_first'.tr()
              : (services.isEmpty
                  ? 'reception_booking.no_services_for_doctor'.tr()
                  : 'reception_booking.choose_service_hint'.tr()),
          sheetTitle: 'reception_booking.select_service'.tr(),
          searchHint: 'reception_booking.choose_service_hint'.tr(),
          prefixIcon: Icons.medical_services_rounded,
          onChanged: onServiceSelected,
        ),
        if (selectedDoctor != null && selectedService == null) ...[
          const SizedBox(height: 6),
          Text(
            'reception_booking.please_select_service_hint'.tr(),
            style: AppTypography.bodySmall.copyWith(
              color: context.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
    final label = srv.isPackage
        ? 'reception_booking.package_sessions_count'.tr(args: [(srv.totalSessions ?? 1).toString()])
        : 'reception_booking.standard_consultation'.tr();
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
              Icon(srv.isPackage ? Icons.all_inclusive : Icons.check_circle_outline,
                  size: 18, color: context.primaryColor),
              const SizedBox(width: AppSpacing.xs),
              Text(label,
                  style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600, color: context.textColor)),
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
