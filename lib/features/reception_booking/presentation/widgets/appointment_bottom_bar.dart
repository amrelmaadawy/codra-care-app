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

class AppointmentBottomBar extends StatelessWidget {
  const AppointmentBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentFormCubit, AppointmentFormState>(
      builder: (context, state) {
        final cubit = context.read<AppointmentFormCubit>();

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
              border: Border(
                top: BorderSide(
                  color: context.dividerColor.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Row(
              children: [
                if (state.stage > 1) ...[
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: state.isSubmitting ? null : cubit.prevStage,
                        icon: const Icon(Icons.arrow_back_rounded, size: 18),
                        label: Text('reception_booking.back_action'.tr()),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  flex: state.stage > 1 ? 2 : 1,
                  child: SizedBox(
                    height: 48,
                    child: _buildActionButton(context, state, cubit),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    AppointmentFormState state,
    AppointmentFormCubit cubit,
  ) {
    if (state.stage == 1) {
      return ElevatedButton.icon(
        onPressed: state.isStage1Valid ? cubit.nextStage : null,
        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
        label: Text(
          'reception_booking.continue_action'.tr(),
          style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        style: _btnStyle(context, isValid: state.isStage1Valid),
      );
    }

    if (state.stage == 2) {
      return ElevatedButton.icon(
        onPressed: state.isStage2Valid ? cubit.nextStage : null,
        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
        label: Text(
          'reception_booking.continue_action'.tr(),
          style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        style: _btnStyle(context, isValid: state.isStage2Valid),
      );
    }

    // Stage 3: Submit
    if (state.isSubmitting) {
      return Container(
        height: 48,
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: const Center(
          child: AppShimmer(
            child: AppShimmerBox(
              width: 150,
              height: 20,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () => cubit.submit(),
      icon: const Icon(Icons.calendar_today_rounded, size: 18),
      label: Text(
        'reception_booking.confirm_appointment_action'.tr(),
        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
      ),
      style: _btnStyle(context, isValid: true),
    );
  }

  ButtonStyle _btnStyle(BuildContext context, {required bool isValid}) {
    return ElevatedButton.styleFrom(
      backgroundColor: isValid
          ? context.primaryColor
          : context.dividerColor.withValues(alpha: 0.5),
      foregroundColor: Colors.white,
      elevation: isValid ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }
}
