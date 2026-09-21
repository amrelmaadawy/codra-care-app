import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubit/prescription_form_cubit.dart';
import '../cubit/prescription_form_state.dart';
import '../widgets/drug_item_form_card.dart';
import '../widgets/prescription_add_drug_button.dart';
import '../widgets/prescription_form_app_bar.dart';
import '../widgets/prescription_form_bottom_bar.dart';
import '../widgets/prescription_notes_card.dart';
import '../widgets/prescription_patient_selector.dart';
import '../widgets/prescription_shimmer.dart';
import '../widgets/previous_prescriptions_sheet.dart';

class PrescriptionFormScreen extends StatefulWidget {
  final int? prescriptionId;
  final int? visitId;
  final int? patientId;

  const PrescriptionFormScreen({
    super.key,
    this.prescriptionId,
    this.visitId,
    this.patientId,
  });

  @override
  State<PrescriptionFormScreen> createState() => _PrescriptionFormScreenState();
}

class _PrescriptionFormScreenState extends State<PrescriptionFormScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PrescriptionFormCubit>().initForm(
          visitId: widget.visitId,
          patientId: widget.patientId,
          prescriptionId: widget.prescriptionId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrescriptionFormCubit, PrescriptionFormState>(
      listener: (context, state) {
        if (state is PrescriptionFormSuccess) {
          final msg = state.isEditing
              ? 'prescription.update_success'.tr()
              : 'prescription.save_success'.tr();
          AppSnackBar.showSuccess(context, msg);
          context.pop(state.prescription);
        } else if (state is PrescriptionFormError) {
          AppSnackBar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final title = widget.prescriptionId != null
            ? 'prescription.edit_prescription'.tr()
            : 'prescription.new_prescription'.tr();

        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: context.backgroundColor,
            appBar: PrescriptionFormAppBar(
              title: title,
              patientName: state is PrescriptionFormReady ? state.selectedPatient?.fullName : null,
              patientCode: state is PrescriptionFormReady ? state.selectedPatient?.patientCode : null,
              itemsCount: state is PrescriptionFormReady
                  ? state.items.where((it) => it.isValid).length
                  : 0,
              previousPrescriptionsCount: state is PrescriptionFormReady
                  ? state.contextData.previousPrescriptions.length
                  : 0,
              onCopyPrevious: state is PrescriptionFormReady &&
                      state.contextData.previousPrescriptions.isNotEmpty
                  ? () => _showPreviousSheet(context, state)
                  : null,
              onBack: () {
                FocusManager.instance.primaryFocus?.unfocus();
                context.pop();
              },
            ),
            bottomNavigationBar: state is PrescriptionFormReady
                ? PrescriptionFormBottomBar(
                    validCount: state.items.where((it) => it.isValid).length,
                    isSubmitting: state.isSubmitting,
                    onSubmit: () => context.read<PrescriptionFormCubit>().submit(),
                  )
                : null,
            body: switch (state) {
              PrescriptionFormLoading() => const PrescriptionShimmer(),
              PrescriptionFormReady() => _buildFormBody(context, state),
              _ => const SizedBox.shrink(),
            },
          ),
        );
      },
    );
  }

  void _showPreviousSheet(BuildContext context, PrescriptionFormReady state) {
    PreviousPrescriptionsSheet.show(
      context: context,
      prescriptions: state.contextData.previousPrescriptions,
      onSelect: (prev) {
        context.read<PrescriptionFormCubit>().copyFromPrevious(prev);
        AppSnackBar.showSuccess(context, 'prescription.copy_success'.tr());
      },
    );
  }

  Widget _buildFormBody(BuildContext context, PrescriptionFormReady state) {
    final cubit = context.read<PrescriptionFormCubit>();

    return ListView(
      padding: AppSpacing.pagePadding,
      children: [
        PrescriptionPatientSelector(
          selectedPatient: state.selectedPatient,
          availablePatients: state.contextData.patients,
          isLocked: widget.visitId != null || widget.patientId != null,
          onSelected: cubit.selectPatient,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          '${'prescription.items'.tr()} (${state.items.length})',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textPrimaryColor,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (var i = 0; i < state.items.length; i++)
          DrugItemFormCard(
            key: ValueKey(state.items[i].id),
            index: i,
            item: state.items[i],
            canDelete: state.items.length > 1,
            contextData: state.contextData,
            onChanged: (updated) => cubit.updateDrugItem(i, updated),
            onDelete: () => cubit.removeDrugItem(i),
          ),
        PrescriptionAddDrugButton(onPressed: cubit.addDrugItem),
        const SizedBox(height: AppSpacing.md),
        PrescriptionNotesCard(
          notes: state.notes,
          quickNotes: state.contextData.quickNotes,
          onChanged: cubit.updateNotes,
        ),
        const SizedBox(height: 90),
      ],
    );
  }
}
