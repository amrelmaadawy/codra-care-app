import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubit/doctor_questions_cubit.dart';
import '../cubit/doctor_questions_state.dart';
import 'doctor_question_predefined_templates.dart';
import 'doctor_question_template_tile.dart';

class DoctorQuestionTemplatesSheet extends StatelessWidget {
  final DoctorQuestionsCubit cubit;

  const DoctorQuestionTemplatesSheet({
    super.key,
    required this.cubit,
  });

  static Future<void> show(BuildContext context, {required DoctorQuestionsCubit cubit}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DoctorQuestionTemplatesSheet(cubit: cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: context.dividerColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: context.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr('doctor_questions.templates_title'),
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.textPrimaryColor,
                          ),
                        ),
                        Text(
                          tr('doctor_questions.templates_subtitle'),
                          style: AppTypography.bodySmall.copyWith(
                            color: context.textMutedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: context.textMutedColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<DoctorQuestionsCubit, DoctorQuestionsState>(
                bloc: cubit,
                builder: (context, state) {
                  final existingTexts = (state is DoctorQuestionsLoaded)
                      ? state.items.map((q) => q.text.trim().toLowerCase()).toSet()
                      : <String>{};

                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: kPredefinedQuestionTemplates.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final tmpl = kPredefinedQuestionTemplates[index];
                      final text = tr(tmpl.textKey);
                      final isAdded = existingTexts.contains(text.trim().toLowerCase());

                      return DoctorQuestionTemplateTile(
                        template: tmpl,
                        isAdded: isAdded,
                        onAdd: () async {
                          final result = await cubit.createQuestion(
                            text: text,
                            type: tmpl.type,
                            options: tmpl.options.isNotEmpty ? tmpl.options : null,
                            isRequired: tmpl.isRequired,
                          );
                          if (!context.mounted) return;
                          result.fold(
                            (f) => AppSnackBar.showError(context, f.message),
                            (_) => AppSnackBar.showSuccess(
                              context,
                              tr('doctor_questions.template_added_success'),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
