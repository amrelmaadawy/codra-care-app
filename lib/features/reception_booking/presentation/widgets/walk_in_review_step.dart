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
              Text(
                'reception_booking.questions_title'.tr(),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...questions.map(
                (q) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '${q.text}${q.required ? ' *' : ''}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                    onChanged: (val) =>
                        cubit.setQuestionAnswer('${q.index}', val),
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
            Text(
              'reception_booking.notes_label'.tr(),
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: context.textColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'reception_booking.notes_hint'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              onChanged: cubit.setNotes,
            ),
          ],
        );
      },
    );
  }

  Widget _buildQueueNotice(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: context.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: context.primaryColor, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'reception_booking.walk_in_queue_notice'.tr(),
              style: AppTypography.bodySmall.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
