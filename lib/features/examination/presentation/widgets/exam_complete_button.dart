import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/examination_cubit.dart';
import '../cubit/examination_state.dart';
import 'exam_complete_dialog.dart';

class ExamCompleteButton extends StatelessWidget {
  final ExaminationLoaded loaded;
  final String complaint;
  final String diagnosis;
  final String notes;
  final int? followupDays;
  final String? followupNotes;
  final List<Map<String, dynamic>> answers;

  const ExamCompleteButton({
    super.key,
    required this.loaded,
    required this.complaint,
    required this.diagnosis,
    required this.notes,
    this.followupDays,
    this.followupNotes,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: loaded.isCompleting
          ? null
          : () {
              ExamCompleteDialog.show(
                context,
                onConfirm: () {
                  final data = {
                    'chief_complaint': complaint.isNotEmpty ? complaint : loaded.visit.chiefComplaint,
                    'diagnosis': diagnosis.isNotEmpty ? diagnosis : loaded.visit.diagnosis,
                    'notes': notes.isNotEmpty ? notes : loaded.visit.notes,
                    'followup_days': followupDays ?? loaded.visit.followupDays,
                    'followup_notes': followupNotes ?? loaded.visit.followupNotes,
                    if (answers.isNotEmpty) 'doctor_answers': answers,
                  };
                  context.read<ExaminationCubit>().completeExamination(data);
                },
              );
            },
      icon: const Icon(Icons.check_circle_rounded, size: 20),
      label: Text(
        'examination.complete_visit'.tr(),
        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
      ),
    );
  }
}
