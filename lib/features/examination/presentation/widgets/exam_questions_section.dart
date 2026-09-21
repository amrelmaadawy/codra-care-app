import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/doctor_question_entity.dart';
import 'exam_draft_indicator.dart';
import 'exam_question_item.dart';
import 'exam_section_card.dart';

class ExamQuestionsSection extends StatefulWidget {
  final List<DoctorQuestionEntity> questions;
  final bool isSaving;
  final bool isSaved;
  final void Function(int questionId, String answer) onAnswerChanged;

  const ExamQuestionsSection({
    super.key,
    required this.questions,
    required this.isSaving,
    required this.isSaved,
    required this.onAnswerChanged,
  });

  @override
  State<ExamQuestionsSection> createState() => _ExamQuestionsSectionState();
}

class _ExamQuestionsSectionState extends State<ExamQuestionsSection> {
  final Map<int, String> _answers = {};

  @override
  void initState() {
    super.initState();
    for (final q in widget.questions) {
      if (q.lastAnswer != null) {
        _answers[q.id] = q.lastAnswer!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExamSectionCard(
      title: 'examination.questions'.tr(),
      icon: Icons.help_outline_rounded,
      trailing: ExamDraftIndicator(
        isSaving: widget.isSaving,
        isSaved: widget.isSaved,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.questions.map((q) {
          final current = _answers[q.id] ?? '';
          return ExamQuestionItem(
            key: ValueKey(q.id),
            question: q,
            currentAnswer: current,
            onAnswerChanged: (ans) {
              setState(() => _answers[q.id] = ans);
              widget.onAnswerChanged(q.id, ans);
            },
          );
        }).toList(),
      ),
    );
  }
}
