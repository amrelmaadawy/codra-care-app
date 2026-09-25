import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../cubits/appointment_form_cubit.dart';
import '../cubits/appointment_form_state.dart';
import 'booking_summary_card.dart';

class QuestionsReviewStep extends StatelessWidget {
  const QuestionsReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentFormCubit, AppointmentFormState>(
      builder: (context, state) {
        final cubit = context.read<AppointmentFormCubit>();
        final questions = state.formContext?.questions ?? [];

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            BookingSummaryCard(state: state),
            const SizedBox(height: AppSpacing.lg),
            if (questions.isNotEmpty) ...[
              Text(
                'reception_booking.questions_title'.tr(),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...questions.map((q) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: q.text,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                    onChanged: (val) =>
                        cubit.setQuestionAnswer('${q.index}', val),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.sm),
            ],
            Text(
              'reception_booking.notes_label'.tr(),
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'reception_booking.notes_hint'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              onChanged: (val) => cubit.setNotes(val),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => cubit.prevStage(),
                    child: Text('reception_booking.back_action'.tr()),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: state.isSubmitting
                      ? Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Center(
                            child: AppShimmer(
                              child: AppShimmerBox(
                                width: 100,
                                height: 18,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () => cubit.submit(),
                          child: Text('reception_booking.submit_action'.tr()),
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
