import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../domain/entities/doctor_question_entity.dart';
import '../cubit/doctor_questions_cubit.dart';
import '../cubit/doctor_questions_state.dart';
import '../widgets/doctor_question_card.dart';
import '../widgets/doctor_question_delete_dialog.dart';
import '../widgets/doctor_question_empty.dart';
import '../widgets/doctor_question_form_sheet.dart';
import '../widgets/doctor_question_preview_sheet.dart';
import '../widgets/doctor_question_shimmer.dart';
import '../widgets/doctor_question_templates_sheet.dart';
import '../widgets/doctor_questions_app_bar.dart';
import '../widgets/doctor_questions_filter_chips.dart';

class DoctorQuestionsScreen extends StatefulWidget {
  const DoctorQuestionsScreen({super.key});

  @override
  State<DoctorQuestionsScreen> createState() => _DoctorQuestionsScreenState();
}

class _DoctorQuestionsScreenState extends State<DoctorQuestionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorQuestionsCubit>().loadQuestions();
  }

  void _openAddSheet() {
    DoctorQuestionFormSheet.show(
      context,
      cubit: context.read<DoctorQuestionsCubit>(),
    );
  }

  void _openPreview(List<DoctorQuestionEntity> questions) {
    DoctorQuestionPreviewSheet.show(context, questions: questions);
  }

  void _openTemplates() {
    DoctorQuestionTemplatesSheet.show(
      context,
      cubit: context.read<DoctorQuestionsCubit>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<DoctorQuestionsCubit, DoctorQuestionsState>(
          builder: (context, state) {
            final count = state is DoctorQuestionsLoaded ? state.items.length : 0;
            return DoctorQuestionsAppBar(
              totalCount: count,
              onPreview: () {
                final list = state is DoctorQuestionsLoaded ? state.items : <DoctorQuestionEntity>[];
                _openPreview(list);
              },
              onTemplates: _openTemplates,
            );
          },
        ),
      ),
      body: BlocBuilder<DoctorQuestionsCubit, DoctorQuestionsState>(
        builder: (context, state) {
          return switch (state) {
            DoctorQuestionsInitial() || DoctorQuestionsLoading() =>
              const DoctorQuestionShimmer(),
            DoctorQuestionsError(:final failure) => AppErrorWidget(
                failure: failure,
                onRetry: () => context.read<DoctorQuestionsCubit>().loadQuestions(),
              ),
            DoctorQuestionsEmpty() => DoctorQuestionEmpty(onAdd: _openAddSheet),
            DoctorQuestionsLoaded() => _buildLoadedBody(context, state),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        backgroundColor: context.primaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildLoadedBody(BuildContext context, DoctorQuestionsLoaded state) {
    final cubit = context.read<DoctorQuestionsCubit>();
    final items = state.filteredItems;

    return Column(
      children: [
        DoctorQuestionsFilterChips(
          selected: state.selectedFilter,
          allCount: state.items.length,
          activeCount: state.activeCount,
          inactiveCount: state.inactiveCount,
          onSelect: cubit.setFilter,
        ),
        if (state.selectedFilter == DoctorQuestionsFilter.all)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 2,
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 13, color: context.textMutedColor),
                const SizedBox(width: 4),
                Text(
                  tr('doctor_questions.drag_hint'),
                  style: TextStyle(fontSize: 11, color: context.textMutedColor),
                ),
              ],
            ),
          ),
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Text(
                    tr('doctor_questions.filter_empty'),
                    style: TextStyle(color: context.textMutedColor),
                  ),
                )
              : ReorderableListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: items.length,
                  buildDefaultDragHandles: false,
                  proxyDecorator: (child, _, _) => Material(
                    elevation: 6,
                    borderRadius: AppRadius.cardRadius,
                    child: child,
                  ),
                  // ignore: deprecated_member_use
                  onReorder: (oldIndex, newIndex) {
                    if (state.selectedFilter != DoctorQuestionsFilter.all) return;
                    if (newIndex > oldIndex) newIndex -= 1;
                    final list = List<DoctorQuestionEntity>.from(state.items);
                    final item = list.removeAt(oldIndex);
                    list.insert(newIndex, item);
                    cubit.reorderQuestions(list);
                  },
                  itemBuilder: (context, index) {
                    final question = items[index];
                    return DoctorQuestionCard(
                      key: ValueKey(question.id),
                      question: question,
                      index: index,
                      onToggle: (_) => cubit.toggleQuestion(question.id),
                      onEdit: () {
                        DoctorQuestionFormSheet.show(
                          context,
                          question: question,
                          cubit: cubit,
                        );
                      },
                      onDelete: () async {
                        final confirmed = await DoctorQuestionDeleteDialog.show(
                          context,
                          questionText: question.text,
                        );
                        if (confirmed == true) {
                          cubit.deleteQuestion(question.id);
                        }
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
