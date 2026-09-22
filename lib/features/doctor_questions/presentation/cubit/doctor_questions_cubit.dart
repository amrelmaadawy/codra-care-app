import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_question_entity.dart';
import '../../domain/use_cases/create_doctor_question_use_case.dart';
import '../../domain/use_cases/delete_doctor_question_use_case.dart';
import '../../domain/use_cases/get_doctor_questions_use_case.dart';
import '../../domain/use_cases/reorder_doctor_questions_use_case.dart';
import '../../domain/use_cases/toggle_doctor_question_use_case.dart';
import '../../domain/use_cases/update_doctor_question_use_case.dart';
import 'doctor_questions_state.dart';

class DoctorQuestionsCubit extends Cubit<DoctorQuestionsState> {
  final GetDoctorQuestionsUseCase getQuestionsUseCase;
  final CreateDoctorQuestionUseCase createQuestionUseCase;
  final UpdateDoctorQuestionUseCase updateQuestionUseCase;
  final DeleteDoctorQuestionUseCase deleteQuestionUseCase;
  final ToggleDoctorQuestionUseCase toggleQuestionUseCase;
  final ReorderDoctorQuestionsUseCase reorderQuestionsUseCase;

  DoctorQuestionsCubit({
    required this.getQuestionsUseCase,
    required this.createQuestionUseCase,
    required this.updateQuestionUseCase,
    required this.deleteQuestionUseCase,
    required this.toggleQuestionUseCase,
    required this.reorderQuestionsUseCase,
  }) : super(const DoctorQuestionsInitial());

  Future<void> loadQuestions() async {
    emit(const DoctorQuestionsLoading());
    final result = await getQuestionsUseCase();
    if (isClosed) return;

    result.fold(
      (f) => emit(DoctorQuestionsError(f)),
      (items) => emit(
        items.isEmpty ? const DoctorQuestionsEmpty() : DoctorQuestionsLoaded(items: items),
      ),
    );
  }

  void setFilter(DoctorQuestionsFilter filter) {
    final current = state;
    if (current is DoctorQuestionsLoaded) {
      emit(current.copyWith(selectedFilter: filter));
    }
  }

  Future<Either<Failure, DoctorQuestionEntity>> createQuestion({
    required String text,
    required DoctorQuestionType type,
    List<String>? options,
    required bool isRequired,
    bool isActive = true,
  }) async {
    _setMutating(true);
    final result = await createQuestionUseCase(
      text: text,
      type: type,
      options: options,
      isRequired: isRequired,
      isActive: isActive,
    );
    if (isClosed) return result;

    result.fold(
      (_) => _setMutating(false),
      (newQ) {
        final current = state;
        if (current is DoctorQuestionsLoaded) {
          emit(current.copyWith(items: [...current.items, newQ], isMutating: false));
        } else {
          emit(DoctorQuestionsLoaded(items: [newQ]));
        }
      },
    );
    return result;
  }

  Future<Either<Failure, DoctorQuestionEntity>> updateQuestion({
    required int id,
    required String text,
    required DoctorQuestionType type,
    List<String>? options,
    required bool isRequired,
  }) async {
    _setMutating(true);
    final result = await updateQuestionUseCase(
      id: id,
      text: text,
      type: type,
      options: options,
      isRequired: isRequired,
    );
    if (isClosed) return result;

    result.fold(
      (_) => _setMutating(false),
      (upQ) {
        final current = state;
        if (current is DoctorQuestionsLoaded) {
          final items = current.items.map((q) => q.id == id ? upQ : q).toList();
          emit(current.copyWith(items: items, isMutating: false));
        }
      },
    );
    return result;
  }

  Future<bool> deleteQuestion(int id) async {
    _setMutating(true);
    final result = await deleteQuestionUseCase(id);
    if (isClosed) return false;

    return result.fold(
      (_) {
        _setMutating(false);
        return false;
      },
      (_) {
        final current = state;
        if (current is DoctorQuestionsLoaded) {
          final items = current.items.where((q) => q.id != id).toList();
          emit(items.isEmpty
              ? const DoctorQuestionsEmpty()
              : current.copyWith(items: items, isMutating: false));
        }
        return true;
      },
    );
  }

  Future<void> toggleQuestion(int id) async {
    final current = state;
    if (current is! DoctorQuestionsLoaded) return;

    final prev = current.items;
    final optimistic = prev.map((q) => q.id == id ? q.copyWith(isActive: !q.isActive) : q).toList();
    emit(current.copyWith(items: optimistic));

    final result = await toggleQuestionUseCase(id);
    if (isClosed) return;

    result.fold(
      (_) => emit(current.copyWith(items: prev)),
      (synced) {
        final items = current.items.map((q) => q.id == id ? synced : q).toList();
        emit(current.copyWith(items: items));
      },
    );
  }

  Future<void> reorderQuestions(List<DoctorQuestionEntity> reordered) async {
    final current = state;
    if (current is! DoctorQuestionsLoaded) return;

    final prev = current.items;
    emit(current.copyWith(items: reordered, isReordering: true));

    final result = await reorderQuestionsUseCase(reordered.map((q) => q.id).toList());
    if (isClosed) return;

    result.fold(
      (_) => emit(current.copyWith(items: prev, isReordering: false)),
      (_) => emit(current.copyWith(isReordering: false)),
    );
  }

  void _setMutating(bool mutating) {
    final current = state;
    if (current is DoctorQuestionsLoaded) {
      emit(current.copyWith(isMutating: mutating));
    }
  }
}
