import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../cubits/appointment_form_cubit.dart';
import '../cubits/appointment_form_state.dart';
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

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text(
              'reception_booking.select_doctor_label'.tr(),
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<int>(
              initialValue: state.selectedDoctor?.id,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.medical_services_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              items: doctors.map((d) {
                return DropdownMenuItem(
                  value: d.id,
                  child: Text('${d.name} (${d.specialization})'),
                );
              }).toList(),
              onChanged: (id) {
                if (id != null) {
                  final doc = doctors.firstWhere((d) => d.id == id);
                  cubit.selectDoctor(doc);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'reception_booking.select_service_label'.tr(),
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<int>(
              initialValue: state.selectedService?.id,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.local_hospital_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              items: services.map((s) {
                return DropdownMenuItem(
                  value: s.id,
                  child: Text(
                    '${s.name} - ${s.price.toStringAsFixed(0)} ${'reception_appointments.currency'.tr()}',
                  ),
                );
              }).toList(),
              onChanged: (id) {
                if (id != null) {
                  final srv = services.firstWhere((s) => s.id == id);
                  cubit.selectService(srv);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'reception_booking.booking_type_label'.tr(),
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              children: types.map((t) {
                final isSelected = state.selectedBookingType == t.value;
                return ChoiceChip(
                  label: Text(t.label),
                  selected: isSelected,
                  onSelected: (_) => cubit.selectBookingType(t.value),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'reception_booking.appointment_date_label'.tr(),
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            InkWell(
              onTap: () => _pickDate(context, state),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: context.dividerColor),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.selectedDate ??
                          'reception_booking.select_date'.tr(),
                    ),
                    Icon(Icons.calendar_month, color: context.primaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (state.selectedDoctor != null) ...[
              Text(
                'reception_booking.available_slots_label'.tr(),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              TimeSlotsGrid(
                availability: state.formContext?.availability,
                isLoading: state.isLoadingSlots,
                selectedSlot: state.selectedSlot,
                onSlotSelected: (slot) => cubit.selectSlot(slot),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => cubit.prevStage(),
                    child: Text('reception_booking.back_action'.tr()),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: state.isStage2Valid
                        ? () => cubit.nextStage()
                        : null,
                    child: Text('reception_booking.continue_action'.tr()),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
