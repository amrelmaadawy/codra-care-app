import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/doctor_question_entity.dart';
import '../cubit/doctor_questions_cubit.dart';
import 'doctor_question_form_header.dart';
import 'doctor_question_options_builder.dart';
import 'doctor_question_required_tile.dart';
import 'doctor_question_type_selector.dart';

class DoctorQuestionFormSheet extends StatefulWidget {
  final DoctorQuestionEntity? question;
  final DoctorQuestionsCubit cubit;

  const DoctorQuestionFormSheet({super.key, this.question, required this.cubit});

  static Future<void> show(
    BuildContext context, {
    DoctorQuestionEntity? question,
    required DoctorQuestionsCubit cubit,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DoctorQuestionFormSheet(question: question, cubit: cubit),
  );

  @override
  State<DoctorQuestionFormSheet> createState() => _DoctorQuestionFormSheetState();
}

class _DoctorQuestionFormSheetState extends State<DoctorQuestionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textCtrl;
  late DoctorQuestionType _selectedType;
  late bool _isRequired;
  final List<TextEditingController> _optionCtrls = [];
  bool _isLoading = false;

  bool get isEdit => widget.question != null;

  @override
  void initState() {
    super.initState();
    final q = widget.question;
    _textCtrl = TextEditingController(text: q?.text ?? '');
    _selectedType = q?.type ?? DoctorQuestionType.text;
    _isRequired = q?.isRequired ?? false;
    final initial = (q != null && q.options.isNotEmpty) ? q.options : ['', ''];
    for (final opt in initial) {
      _optionCtrls.add(TextEditingController(text: opt));
    }
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    for (final c in _optionCtrls) { c.dispose(); }
    super.dispose();
  }

  void _addOption() => setState(() => _optionCtrls.add(TextEditingController()));

  void _removeOption(int i) {
    if (_optionCtrls.length > 2) setState(() => _optionCtrls.removeAt(i).dispose());
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final isMulti = _selectedType == DoctorQuestionType.multipleChoice;
    final options = isMulti
        ? _optionCtrls.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList()
        : null;

    if (isMulti) {
      if ((options?.length ?? 0) < 2) {
        AppSnackBar.showError(context, tr('doctor_questions.validation.options_min'));
        return;
      }
      if (options!.map((s) => s.toLowerCase()).toSet().length != options.length) {
        AppSnackBar.showError(context, tr('doctor_questions.validation.option_duplicate'));
        return;
      }
    }

    setState(() => _isLoading = true);
    final text = _textCtrl.text.trim();
    final result = isEdit
        ? await widget.cubit.updateQuestion(
            id: widget.question!.id,
            text: text,
            type: _selectedType,
            options: options,
            isRequired: _isRequired,
          )
        : await widget.cubit.createQuestion(
            text: text,
            type: _selectedType,
            options: options,
            isRequired: _isRequired,
          );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (f) => AppSnackBar.showError(context, f.message),
      (_) {
        Navigator.of(context).pop();
        AppSnackBar.showSuccess(
          context,
          tr(isEdit ? 'doctor_questions.updated_success' : 'doctor_questions.created_success'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DoctorQuestionFormHeader(
                  isEdit: isEdit,
                  onClose: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  tr('doctor_questions.fields.question_text'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                AppTextField(
                  controller: _textCtrl,
                  hintKey: 'doctor_questions.fields.question_text',
                  maxLines: 2,
                  validator: (v) {
                    if (v == null || v.trim().length < 3) {
                      return tr('doctor_questions.validation.text_required');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                DoctorQuestionTypeSelector(
                  selectedType: _selectedType,
                  onTypeChanged: (t) => setState(() => _selectedType = t),
                ),
                const SizedBox(height: AppSpacing.md),
                DoctorQuestionRequiredTile(
                  isRequired: _isRequired,
                  onChanged: (v) => setState(() => _isRequired = v),
                ),
                if (_selectedType == DoctorQuestionType.multipleChoice) ...[
                  const SizedBox(height: AppSpacing.md),
                  DoctorQuestionOptionsBuilder(
                    controllers: _optionCtrls,
                    onAdd: _addOption,
                    onRemove: _removeOption,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  labelKey: isEdit ? 'common.save' : 'common.add',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
