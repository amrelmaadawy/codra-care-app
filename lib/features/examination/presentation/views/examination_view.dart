import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/safe_tr_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubit/examination_cubit.dart';
import '../cubit/examination_state.dart';
import '../widgets/exam_app_bar.dart';
import '../widgets/exam_complete_button.dart';
import '../widgets/exam_followup_section.dart';
import '../widgets/exam_images_section.dart';
import '../widgets/exam_notes_section.dart';
import '../widgets/exam_patient_header.dart';
import '../widgets/exam_prescription_button.dart';
import '../widgets/exam_previous_visits_sheet.dart';
import '../widgets/exam_questions_section.dart';
import '../widgets/exam_shimmer.dart';
import '../widgets/exam_vital_signs_section.dart';

class ExaminationView extends StatefulWidget {
  const ExaminationView({super.key});
  @override
  State<ExaminationView> createState() => _ExaminationViewState();
}

class _ExaminationViewState extends State<ExaminationView> {
  String _complaint = '';
  String _diagnosis = '';
  String _notes = '';
  int? _followupDays;
  String? _followupNotes;
  final List<Map<String, dynamic>> _answers = [];

  void _snack(BuildContext context, String msg, {bool isError = false}) =>
      isError ? AppSnackBar.showError(context, msg) : AppSnackBar.showSuccess(context, msg);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExaminationCubit, ExaminationState>(
      listener: (context, state) {
        if (state is! ExaminationLoaded) return;
        final v = state.visit;
        if (_complaint.isEmpty && v.chiefComplaint != null) _complaint = v.chiefComplaint!;
        if (_diagnosis.isEmpty && v.diagnosis != null) _diagnosis = v.diagnosis!;
        if (_notes.isEmpty && v.notes != null) _notes = v.notes!;
        if (_followupDays == null && v.followupDays != null) _followupDays = v.followupDays;
        if (_followupNotes == null && v.followupNotes != null) _followupNotes = v.followupNotes;

        if (state.errorMessage != null) _snack(context, state.errorMessage!, isError: true);
        if (state.successMessage != null) _snack(context, state.successMessage!);
        if (state.isCompleted) {
          _snack(context, 'examination.complete_success');
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final title = 'examination.title'.tr();

        if (state is ExaminationLoading || state is ExaminationInitial) {
          return Scaffold(appBar: AppBar(title: Text(title)), body: const ExamShimmer());
        }

        if (state is ExaminationError) {
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message.trOrSelf(), style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => context.read<ExaminationCubit>().loadExamination(),
                    child: Text('common.retry'.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        final loaded = state as ExaminationLoaded;
        final visit = loaded.visit;

        return PopScope(
          canPop: !loaded.isAnySectionSaving,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && loaded.isAnySectionSaving) {
              _snack(context, 'examination.saving_in_progress'.tr(), isError: true);
            }
          },
          child: Scaffold(
            appBar: ExamAppBar(
              patient: visit.patient,
              ticketNumber: visit.visitNumber,
              isSaving: loaded.isAnySectionSaving,
              isSaved: loaded.isAnySectionSaved,
              pastVisitsCount: visit.pastVisitsCount,
              onBackTap: () {
                if (!loaded.isAnySectionSaving) {
                  Navigator.of(context).pop();
                } else {
                  _snack(context, 'examination.saving_in_progress'.tr(), isError: true);
                }
              },
              onHistoryTap: () => ExamPreviousVisitsSheet.show(
                context,
                previousVisits: visit.previousVisits,
                onCopy: (prevId) => context.read<ExaminationCubit>().copyPreviousVisit(prevId),
              ),
            ),
          body: SingleChildScrollView(
            padding: AppSpacing.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ExamPatientHeader(
                  patient: visit.patient,
                  visitNumber: visit.visitNumber,
                  visitTypeLabel: visit.visitTypeLabel,
                  isFirstVisit: visit.isFirstVisit,
                  pastVisitsCount: visit.pastVisitsCount,
                  onPreviousVisitsTap: () => ExamPreviousVisitsSheet.show(
                    context,
                    previousVisits: visit.previousVisits,
                    onCopy: (prevId) => context.read<ExaminationCubit>().copyPreviousVisit(prevId),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ExamVitalSignsSection(vitalSigns: visit.vitalSigns),
                const SizedBox(height: AppSpacing.md),
                ExamQuestionsSection(
                  questions: visit.questions,
                  isSaving: loaded.isSectionSaving('doctor_answers'),
                  isSaved: loaded.isSectionSaved('doctor_answers'),
                  onAnswerChanged: (qId, ans) {
                    _answers.removeWhere((e) => e['question_id'] == qId);
                    _answers.add({'question_id': qId, 'answer': ans});
                    context.read<ExaminationCubit>().autoSaveSection(
                      'doctor_answers',
                      {'answers': _answers},
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                ExamNotesSection(
                  initialComplaint: visit.chiefComplaint,
                  initialDiagnosis: visit.diagnosis,
                  initialNotes: visit.notes,
                  complaintTemplates: visit.complaintTemplates,
                  diagnosisTemplates: visit.diagnosisTemplates,
                  isSaving: loaded.isSectionSaving('examination_notes'),
                  isSaved: loaded.isSectionSaved('examination_notes'),
                  onChanged: ({required complaint, required diagnosis, required notes}) {
                    _complaint = complaint;
                    _diagnosis = diagnosis;
                    _notes = notes;
                    context.read<ExaminationCubit>().autoSaveSection(
                      'examination_notes',
                      {
                        'chief_complaint': complaint,
                        'diagnosis': diagnosis,
                        'notes': notes,
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                ExamFollowupSection(
                  initialDays: visit.followupDays,
                  initialNotes: visit.followupNotes,
                  isSaving: loaded.isSectionSaving('followup'),
                  isSaved: loaded.isSectionSaved('followup'),
                  onChanged: (days, fNotes) {
                    _followupDays = days;
                    _followupNotes = fNotes;
                    context.read<ExaminationCubit>().autoSaveSection(
                      'followup',
                      {
                        'followup_days': days,
                        'followup_notes': fNotes,
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                ExamImagesSection(
                  images: visit.images,
                  isUploading: loaded.isUploading,
                  onUpload: (paths, type, desc) =>
                      context.read<ExaminationCubit>().uploadFiles(paths, type, desc),
                  onDelete: (imgId) => context.read<ExaminationCubit>().deleteFile(imgId),
                ),
                const SizedBox(height: AppSpacing.lg),
                ExamPrescriptionButton(
                  visitId: visit.id,
                  patientId: visit.patient.id,
                ),
                const SizedBox(height: AppSpacing.lg),
                ExamCompleteButton(
                  loaded: loaded,
                  complaint: _complaint,
                  diagnosis: _diagnosis,
                  notes: _notes,
                  followupDays: _followupDays,
                  followupNotes: _followupNotes,
                  answers: _answers,
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      );
      },
    );
  }
}
