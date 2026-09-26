import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubits/appointment_form_cubit.dart';
import '../cubits/appointment_form_state.dart';
import '../widgets/appointment_bottom_bar.dart';
import '../widgets/appointment_form_app_bar.dart';
import '../widgets/appointment_stage_indicator.dart';
import '../widgets/patient_selection_step.dart';
import '../widgets/questions_review_step.dart';
import '../widgets/schedule_selection_step.dart';

class AppointmentFormView extends StatelessWidget {
  const AppointmentFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentFormCubit, AppointmentFormState>(
      listener: (context, state) {
        if (state.submitSuccess) {
          AppSnackBar.showSuccess(
            context,
            'reception_booking.create_success'.tr(),
          );
          Navigator.of(context).pop(true);
        }
        if (state.submitError != null) {
          AppSnackBar.showError(context, state.submitError!);
        }
      },
      builder: (context, state) {
        final cubit = context.read<AppointmentFormCubit>();

        return Scaffold(
          appBar: const AppointmentFormAppBar(),
          bottomNavigationBar: const AppointmentBottomBar(),
          body: Column(
            children: [
              AppointmentStageIndicator(
                currentStage: state.stage,
                onStageTapped: (target) => cubit.goToStage(target),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: _buildStageContent(context, state, cubit),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStageContent(
    BuildContext context,
    AppointmentFormState state,
    AppointmentFormCubit cubit,
  ) {
    if (state.isLoadingContext && state.formContext == null) {
      return const AppShimmer(
        child: Column(
          children: [
            AppShimmerBox(
              width: double.infinity,
              height: 48,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            SizedBox(height: 16),
            AppShimmerBox(
              width: double.infinity,
              height: 52,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            SizedBox(height: 16),
            AppShimmerBox(
              width: double.infinity,
              height: 52,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ],
        ),
      );
    }

    if (state.contextError != null && state.formContext == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text(state.contextError!, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => cubit.init(),
                child: Text('reception_booking.retry_action'.tr()),
              ),
            ],
          ),
        ),
      );
    }

    switch (state.stage) {
      case 1:
        return const PatientSelectionStep();
      case 2:
        return const ScheduleSelectionStep();
      case 3:
        return const QuestionsReviewStep();
      default:
        return const PatientSelectionStep();
    }
  }
}
