import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_dropdown_sheet.dart';
import '../../domain/entities/booking_doctor_entity.dart';
import '../../domain/entities/booking_service_entity.dart';
import '../cubits/appointment_form_cubit.dart';
import '../cubits/appointment_form_state.dart';
import 'booking_date_picker_card.dart';
import 'time_slots_grid.dart';

class ScheduleSelectionStep extends StatelessWidget {
  const ScheduleSelectionStep({super.key});

  Future<void> _pickDate(
    BuildContext context,
    AppointmentFormState state,
  ) async {
    final cubit = context.read<AppointmentFormCubit>();
    final current =
        DateTime.tryParse(state.selectedDate ?? '') ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      final dateStr =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      cubit.selectDate(dateStr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentFormCubit, AppointmentFormState>(
      builder: (context, state) {
        final cubit = context.read<AppointmentFormCubit>();
        final doctors = state.formContext?.doctors ?? [];
        final services = state.formContext?.services ?? [];
        final types = state.formContext?.bookingTypes ?? [];

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
              selectedItem: state.selectedDoctor,
              itemLabel: (doc) => '${doc.name} (${doc.specialization})',
              onSelected: cubit.selectDoctor,
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
              selectedItem: state.selectedService,
              itemLabel: (srv) =>
                  '${srv.name} — ${srv.price.toStringAsFixed(0)} ${'reception_booking.currency'.tr()}',
              onSelected: cubit.selectService,
              searchHint: state.selectedDoctor == null
                  ? 'reception_booking.select_doctor_first'.tr()
                  : 'reception_booking.choose_service_hint'.tr(),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildSectionHeader(
              context,
              icon: Icons.category_rounded,
              title: 'reception_booking.booking_type_label'.tr(),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: types.map((t) {
                final isSelected = state.selectedBookingType == t.value;
                return ChoiceChip(
                  label: Text(t.label),
                  selected: isSelected,
                  selectedColor: context.primaryColor.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? context.primaryColor : context.textColor,
                  ),
                  onSelected: (_) => cubit.selectBookingType(t.value),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildSectionHeader(
              context,
              icon: Icons.event_available_rounded,
              title: 'reception_booking.appointment_date_label'.tr(),
            ),
            const SizedBox(height: AppSpacing.xs),
            BookingDatePickerCard(
              selectedDate: state.selectedDate,
              onTap: () => _pickDate(context, state),
            ),
            if (state.selectedDoctor != null) ...[
              const SizedBox(height: AppSpacing.md),
              _buildSectionHeader(
                context,
                icon: Icons.access_time_rounded,
                title: 'reception_booking.available_slots_label'.tr(),
              ),
              const SizedBox(height: AppSpacing.xs),
              TimeSlotsGrid(
                availability: state.formContext?.availability,
                isLoading: state.isLoadingSlots,
                selectedSlot: state.selectedSlot,
                onSlotSelected: cubit.selectSlot,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.primaryColor),
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
}
