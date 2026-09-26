import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../cubits/appointment_form_cubit.dart';
import '../cubits/appointment_form_state.dart';
import 'inline_new_patient_form.dart';
import 'patient_search_card.dart';
import 'walk_in_patient_tab_selector.dart';

class PatientSelectionStep extends StatefulWidget {
  const PatientSelectionStep({super.key});

  @override
  State<PatientSelectionStep> createState() => _PatientSelectionStepState();
}

class _PatientSelectionStepState extends State<PatientSelectionStep> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentFormCubit, AppointmentFormState>(
      builder: (context, state) {
        final cubit = context.read<AppointmentFormCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WalkInPatientTabSelector(
              isNewPatient: state.isNewPatient,
              onToggle: cubit.toggleNewPatient,
            ),
            const SizedBox(height: AppSpacing.md),
            if (state.isNewPatient)
              InlineNewPatientForm(
                initialValue: state.newPatient,
                onChanged: (params) {
                  if (params != null) cubit.setNewPatient(params);
                },
              )
            else ...[
              _buildSearchField(context, cubit),
              const SizedBox(height: AppSpacing.sm),
              _buildSearchTip(context),
              const SizedBox(height: AppSpacing.md),
              if (state.isSearching) ...[
                _buildSearchShimmer(),
              ] else if (state.searchResults.isNotEmpty) ...[
                Text(
                  'reception_booking.search_results'.tr(),
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                ...state.searchResults.map(
                  (p) => PatientSearchCard(
                    patient: p,
                    isSelected: state.selectedPatient?.id == p.id,
                    onSelect: () => cubit.selectPatient(p),
                  ),
                ),
              ] else if (_searchCtrl.text.trim().isNotEmpty) ...[
                _buildNoPatientsFound(context),
              ],
            ],
          ],
        );
      },
    );
  }

  Widget _buildSearchField(BuildContext context, AppointmentFormCubit cubit) {
    return TextField(
      controller: _searchCtrl,
      onChanged: cubit.searchPatients,
      decoration: InputDecoration(
        hintText: 'reception_booking.search_patient_tip'.tr(),
        prefixIcon: Icon(Icons.search_rounded, color: context.primaryColor),
        suffixIcon: _searchCtrl.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: () {
                  _searchCtrl.clear();
                  cubit.searchPatients('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: context.primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSearchTip(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 14,
          color: context.textMutedColor,
        ),
        const SizedBox(width: 4),
        Text(
          'reception_booking.search_patient_tip'.tr(),
          style: AppTypography.bodySmall.copyWith(
            fontSize: 11,
            color: context.textMutedColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchShimmer() {
    return const AppShimmer(
      child: Column(
        children: [
          AppShimmerBox(
            width: double.infinity,
            height: 64,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          SizedBox(height: 8),
          AppShimmerBox(
            width: double.infinity,
            height: 64,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoPatientsFound(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 36,
              color: context.textMutedColor,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'reception_booking.no_patients_found'.tr(),
              style: AppTypography.bodySmall.copyWith(
                color: context.textMutedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
