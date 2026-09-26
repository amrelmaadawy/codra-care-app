import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BookingSummaryCard(state: state),
            const SizedBox(height: AppSpacing.lg),
            if (questions.isNotEmpty) ...[
              _buildSectionTitle(
                context,
                icon: Icons.help_outline_rounded,
                title: 'reception_booking.questions_title'.tr(),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...questions.map(
                (q) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '${q.text}${q.required ? ' *' : ''}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(
                          color: context.primaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: (val) =>
                        cubit.setQuestionAnswer('${q.index}', val),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            _buildSectionTitle(
              context,
              icon: Icons.notes_rounded,
              title: 'reception_booking.notes_label'.tr(),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'reception_booking.notes_hint'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide(
                    color: context.primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: cubit.setNotes,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: context.primaryColor),
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
