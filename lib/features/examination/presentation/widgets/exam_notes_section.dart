import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/doctor_template_entity.dart';
import 'exam_draft_indicator.dart';
import 'exam_notes_field.dart';
import 'exam_section_card.dart';

class ExamNotesSection extends StatefulWidget {
  final String? initialComplaint;
  final String? initialDiagnosis;
  final String? initialNotes;
  final List<DoctorTemplateEntity> complaintTemplates;
  final List<DoctorTemplateEntity> diagnosisTemplates;
  final bool isSaving;
  final bool isSaved;
  final void Function({
    required String complaint,
    required String diagnosis,
    required String notes,
  }) onChanged;

  const ExamNotesSection({
    super.key,
    this.initialComplaint,
    this.initialDiagnosis,
    this.initialNotes,
    this.complaintTemplates = const [],
    this.diagnosisTemplates = const [],
    required this.isSaving,
    required this.isSaved,
    required this.onChanged,
  });

  @override
  State<ExamNotesSection> createState() => _ExamNotesSectionState();
}

class _ExamNotesSectionState extends State<ExamNotesSection> {
  late final TextEditingController _complaintController;
  late final TextEditingController _diagnosisController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _complaintController = TextEditingController(text: widget.initialComplaint ?? '');
    _diagnosisController = TextEditingController(text: widget.initialDiagnosis ?? '');
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
  }

  @override
  void didUpdateWidget(covariant ExamNotesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialComplaint != oldWidget.initialComplaint) {
      _complaintController.text = widget.initialComplaint ?? '';
    }
    if (widget.initialDiagnosis != oldWidget.initialDiagnosis) {
      _diagnosisController.text = widget.initialDiagnosis ?? '';
    }
    if (widget.initialNotes != oldWidget.initialNotes) {
      _notesController.text = widget.initialNotes ?? '';
    }
  }

  @override
  void dispose() {
    _complaintController.dispose();
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onChanged(
      complaint: _complaintController.text,
      diagnosis: _diagnosisController.text,
      notes: _notesController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExamSectionCard(
      title: 'examination.chief_complaint'.tr(),
      icon: Icons.edit_note_rounded,
      trailing: ExamDraftIndicator(
        isSaving: widget.isSaving,
        isSaved: widget.isSaved,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExamNotesField(
            controller: _complaintController,
            label: 'examination.chief_complaint'.tr(),
            hint: 'examination.chief_complaint_hint'.tr(),
            isRequired: true,
            templates: widget.complaintTemplates,
            onChanged: _notifyChange,
          ),
          const SizedBox(height: AppSpacing.md),
          ExamNotesField(
            controller: _diagnosisController,
            label: 'examination.diagnosis'.tr(),
            hint: 'examination.diagnosis_hint'.tr(),
            isRequired: true,
            templates: widget.diagnosisTemplates,
            onChanged: _notifyChange,
          ),
          const SizedBox(height: AppSpacing.md),
          ExamNotesField(
            controller: _notesController,
            label: 'examination.notes'.tr(),
            hint: 'examination.notes_hint'.tr(),
            onChanged: _notifyChange,
          ),
        ],
      ),
    );
  }
}
