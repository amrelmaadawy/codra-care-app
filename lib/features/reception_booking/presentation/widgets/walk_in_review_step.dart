import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../cubits/walk_in_cubit.dart';
import '../cubits/walk_in_state.dart';
import 'walk_in_summary_card.dart';
import 'walk_in_vitals_section.dart';

class WalkInReviewStep extends StatelessWidget {
  const WalkInReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkInCubit, WalkInState>(
      builder: (context, state) {
        final cubit = context.read<WalkInCubit>();
        final questions = state.formContext?.questions ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WalkInSummaryCard(state: state),
            const SizedBox(height: AppSpacing.md),
            _buildQueueNotice(context),
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
                        borderSide: BorderSide(color: context.primaryColor, width: 1.5),
                      ),
                    ),
                    onChanged: (val) => cubit.setQuestionAnswer('${q.index}', val),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            WalkInVitalsSection(
              vitalSigns: state.vitalSigns,
              onVitalChanged: cubit.setVitalSign,
            ),
            const SizedBox(height: AppSpacing.md),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide(color: context.primaryColor, width: 1.5),
                ),
              ),
              onChanged: cubit.setNotes,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, {required IconData icon, required String title}) {
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

  Widget _buildQueueNotice(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.primaryColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: context.primaryColor, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'reception_booking.walk_in_queue_notice'.tr(),
              style: AppTypography.bodySmall.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
