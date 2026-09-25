import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../cubits/walk_in_cubit.dart';
import '../cubits/walk_in_state.dart';
import 'inline_new_patient_form.dart';
import 'patient_search_card.dart';

class WalkInPatientStep extends StatefulWidget {
  const WalkInPatientStep({super.key});

  @override
  State<WalkInPatientStep> createState() => _WalkInPatientStepState();
}

class _WalkInPatientStepState extends State<WalkInPatientStep> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkInCubit, WalkInState>(
      builder: (context, state) {
        final cubit = context.read<WalkInCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: false,
                  label: Text('reception_booking.tab_existing_patient'.tr()),
                  icon: const Icon(Icons.person_search),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('reception_booking.tab_new_patient'.tr()),
                  icon: const Icon(Icons.person_add_alt_1),
                ),
              ],
              selected: {state.isNewPatient},
              onSelectionChanged: (val) => cubit.toggleNewPatient(val.first),
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
              TextField(
                controller: _searchCtrl,
                onChanged: cubit.searchPatients,
                decoration: InputDecoration(
                  hintText: 'reception_booking.search_patient_hint'.tr(),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            cubit.searchPatients('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (state.isSearching) ...[
                const AppShimmer(
                  child: Column(
                    children: [
                      AppShimmerBox(
                        width: double.infinity,
                        height: 60,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      SizedBox(height: 8),
                      AppShimmerBox(
                        width: double.infinity,
                        height: 60,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ],
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(
                    child: Text(
                      'reception_booking.no_patients_found'.tr(),
                      style: AppTypography.bodySmall,
                    ),
                  ),
                ),
              ],
            ],
          ],
        );
      },
    );
  }
}
