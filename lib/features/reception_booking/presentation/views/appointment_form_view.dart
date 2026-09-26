import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/theme_extensions.dart';
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
              if (state.isFollowUpMode &&
                  state.followUpInstructions != null &&
                  state.followUpInstructions!.isNotEmpty)
                _buildFollowUpBanner(context, state.followUpInstructions!),
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

  Widget _buildFollowUpBanner(BuildContext context, String instructions) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.infoLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.info,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'reception_booking.follow_up_instructions'.tr(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  instructions,
                  style: TextStyle(fontSize: 12, color: context.textColor),
                ),
              ],
            ),
          ),
        ],
      ),
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
