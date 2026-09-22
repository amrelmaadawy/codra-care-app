import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/doctor_question_entity.dart';
import 'doctor_question_preview_item.dart';

class DoctorQuestionPreviewSheet extends StatefulWidget {
  final List<DoctorQuestionEntity> questions;

  const DoctorQuestionPreviewSheet({
    super.key,
    required this.questions,
  });

  static Future<void> show(
    BuildContext context, {
    required List<DoctorQuestionEntity> questions,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DoctorQuestionPreviewSheet(questions: questions),
  );

  @override
  State<DoctorQuestionPreviewSheet> createState() => _DoctorQuestionPreviewSheetState();
}

class _DoctorQuestionPreviewSheetState extends State<DoctorQuestionPreviewSheet> {
  final Map<int, dynamic> _answers = {};

  List<DoctorQuestionEntity> get _activeQuestions =>
      widget.questions.where((q) => q.isActive).toList();

  @override
  Widget build(BuildContext context) {
    final active = _activeQuestions;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
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
                      Icons.preview_rounded,
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
                          tr('doctor_questions.preview_title'),
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.textPrimaryColor,
                          ),
                        ),
                        Text(
                          tr('doctor_questions.preview_subtitle'),
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
              child: active.isEmpty
                  ? Center(
                      child: Text(
                        tr('doctor_questions.preview_empty'),
                        style: AppTypography.bodyMedium.copyWith(
                          color: context.textMutedColor,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: active.length,
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final q = active[index];
                        return DoctorQuestionPreviewItem(
                          question: q,
                          number: index + 1,
                          currentAnswer: _answers[q.id],
                          onAnswerChanged: (val) => setState(() => _answers[q.id] = val),
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
