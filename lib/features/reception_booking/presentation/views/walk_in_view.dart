import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubits/walk_in_cubit.dart';
import '../cubits/walk_in_state.dart';
import '../widgets/walk_in_bottom_bar.dart';
import '../widgets/walk_in_doctor_service_step.dart';
import '../widgets/walk_in_patient_step.dart';
import '../widgets/walk_in_review_step.dart';
import '../widgets/walk_in_stage_indicator.dart';

class WalkInView extends StatelessWidget {
  const WalkInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalkInCubit, WalkInState>(
      listener: (context, state) {
        if (state.submitSuccess) {
          final ticket = state.walkInResult?.ticketNumber;
          final msg = ticket != null && ticket.isNotEmpty
              ? 'reception_booking.walk_in_success_with_ticket'.tr(args: [ticket])
              : 'reception_booking.walk_in_success'.tr();
          AppSnackBar.showSuccess(context, msg);
          Navigator.of(context).pop(true);
        }
        if (state.submitError != null) {
          AppSnackBar.showError(context, state.submitError!);
        }
      },
      builder: (context, state) {
        final cubit = context.read<WalkInCubit>();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'reception_booking.walk_in_title'.tr(),
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          bottomNavigationBar: const WalkInBottomBar(),
          body: Column(
            children: [
              WalkInStageIndicator(
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
    WalkInState state,
    WalkInCubit cubit,
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
        return const WalkInPatientStep();
      case 2:
        return WalkInDoctorServiceStep(
          formContext: state.formContext,
          selectedDoctor: state.selectedDoctor,
          selectedService: state.selectedService,
          selectedPriority: state.selectedPriority,
          selectedBookingType: state.selectedBookingType,
          onDoctorSelected: cubit.selectDoctor,
          onServiceSelected: cubit.selectService,
          onPriorityChanged: cubit.selectPriority,
          onBookingTypeChanged: (type) {},
        );
      case 3:
        return const WalkInReviewStep();
      default:
        return const WalkInPatientStep();
    }
  }
}
