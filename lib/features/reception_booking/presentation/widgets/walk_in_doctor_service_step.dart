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
        Text(
          'reception_booking.doctor_selection_title'.tr(),
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
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
        Text(
          'reception_booking.service_selection_title'.tr(),
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
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
        const SizedBox(height: AppSpacing.md),
        Text(
          'reception_booking.priority_title'.tr(),
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        _buildPriorityChips(context),
        if (selectedPriority == 'urgent') ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            'reception_booking.urgent_walk_in_warning'.tr(),
            style: AppTypography.labelSmall.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildServiceSummary(BuildContext context, BookingServiceEntity srv) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                srv.isPackage ? Icons.all_inclusive : Icons.check_circle_outline,
                size: 16,
                color: context.primaryColor,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                srv.isPackage
                    ? 'reception_booking.package_sessions_count'.tr(args: [
                        (srv.totalSessions ?? 1).toString(),
                      ])
                    : 'reception_booking.standard_consultation'.tr(),
                style: AppTypography.bodySmall.copyWith(color: context.textColor),
              ),
            ],
          ),
          Text(
            '${srv.price.toStringAsFixed(0)} ${'reception_booking.currency'.tr()}',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChips(BuildContext context) {
    final priorities = [
      ('normal', 'reception_booking.priority_normal'.tr()),
      ('urgent', 'reception_booking.priority_urgent'.tr()),
      ('vip', 'reception_booking.priority_vip'.tr()),
    ];

    return Row(
      children: priorities.map((p) {
        final selected = selectedPriority == p.$1;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(p.$2),
              selected: selected,
              onSelected: (_) => onPriorityChanged(p.$1),
              selectedColor: context.primaryColor.withValues(alpha: 0.15),
              labelStyle: TextStyle(
                color: selected ? context.primaryColor : context.textColor,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
