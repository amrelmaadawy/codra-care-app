import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/entities/diagnosis_template_entity.dart';
import '../cubit/diagnosis_template_list_cubit.dart';
import 'diagnosis_template_form_field.dart';
import 'diagnosis_template_form_header.dart';

class DiagnosisTemplateFormSheet extends StatefulWidget {
  final DiagnosisTemplateEntity? template;
  final DiagnosisTemplateListCubit cubit;

  const DiagnosisTemplateFormSheet({
    super.key,
    this.template,
    required this.cubit,
  });

  static Future<void> show(
    BuildContext context, {
    DiagnosisTemplateEntity? template,
    required DiagnosisTemplateListCubit cubit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DiagnosisTemplateFormSheet(template: template, cubit: cubit),
    );
  }

  @override
  State<DiagnosisTemplateFormSheet> createState() => _DiagnosisTemplateFormSheetState();
}

class _DiagnosisTemplateFormSheetState extends State<DiagnosisTemplateFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _complaintCtrl;
  late final TextEditingController _diagnosisCtrl;
  late final TextEditingController _notesCtrl;
  bool _isLoading = false;

  bool get isEdit => widget.template != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.template?.title ?? '');
    _complaintCtrl = TextEditingController(text: widget.template?.chiefComplaint ?? '');
    _diagnosisCtrl = TextEditingController(text: widget.template?.diagnosis ?? '');
    _notesCtrl = TextEditingController(text: widget.template?.notes ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _complaintCtrl.dispose();
    _diagnosisCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final complaint = _complaintCtrl.text.trim();
    final diagnosis = _diagnosisCtrl.text.trim();
    final notes = _notesCtrl.text.trim();

    if (complaint.isEmpty && diagnosis.isEmpty && notes.isEmpty) {
      AppSnackBar.showError(context, tr('diagnosis_template.validation_at_least_one'));
      return;
    }

    setState(() => _isLoading = true);

    final res = isEdit
        ? await widget.cubit.updateTemplate(
            id: widget.template!.id,
            title: _titleCtrl.text.trim(),
            chiefComplaint: complaint.isEmpty ? null : complaint,
            diagnosis: diagnosis.isEmpty ? null : diagnosis,
            notes: notes.isEmpty ? null : notes,
          )
        : await widget.cubit.createTemplate(
            title: _titleCtrl.text.trim(),
            chiefComplaint: complaint.isEmpty ? null : complaint,
            diagnosis: diagnosis.isEmpty ? null : diagnosis,
            notes: notes.isEmpty ? null : notes,
          );

    if (!mounted) return;
    setState(() => _isLoading = false);

    res.fold(
      (f) => AppSnackBar.showError(context, f.message),
      (_) {
        AppSnackBar.showSuccess(
          context,
          tr(isEdit ? 'diagnosis_template.updated_success' : 'diagnosis_template.created_success'),
        );
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          DiagnosisTemplateFormHeader(
            isEdit: isEdit,
            onClose: () => Navigator.of(context).pop(),
          ),
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTipCard(context),
                    const SizedBox(height: AppSpacing.md),
                    DiagnosisTemplateFormField(
                      controller: _titleCtrl,
                      label: tr('diagnosis_template.fields.title'),
                      hint: tr('diagnosis_template.hints.title'),
                      icon: Icons.title_rounded,
                      isRequired: true,
                      validator: (v) {
                        if (v == null || v.trim().length < 2) {
                          return tr('diagnosis_template.validation_title');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DiagnosisTemplateFormField(
                      controller: _diagnosisCtrl,
                      label: tr('diagnosis_template.fields.diagnosis'),
                      hint: tr('diagnosis_template.hints.diagnosis'),
                      icon: Icons.medical_information_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DiagnosisTemplateFormField(
                      controller: _complaintCtrl,
                      label: tr('diagnosis_template.fields.chief_complaint'),
                      hint: tr('diagnosis_template.hints.chief_complaint'),
                      icon: Icons.chat_bubble_outline_rounded,
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DiagnosisTemplateFormField(
                      controller: _notesCtrl,
                      label: tr('diagnosis_template.fields.notes'),
                      hint: tr('diagnosis_template.hints.notes'),
                      icon: Icons.article_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      labelKey: isEdit ? 'common.save' : 'common.add',
                      isLoading: _isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.primaryColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: context.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tr('diagnosis_template.tip_at_least_one'),
              style: TextStyle(fontSize: 11, color: context.primaryColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
