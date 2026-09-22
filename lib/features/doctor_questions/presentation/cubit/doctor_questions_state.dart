import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_question_entity.dart';

enum DoctorQuestionsFilter { all, active, inactive }

sealed class DoctorQuestionsState extends Equatable {
  const DoctorQuestionsState();

  @override
  List<Object?> get props => [];
}

class DoctorQuestionsInitial extends DoctorQuestionsState {
  const DoctorQuestionsInitial();
}

class DoctorQuestionsLoading extends DoctorQuestionsState {
  const DoctorQuestionsLoading();
}

class DoctorQuestionsLoaded extends DoctorQuestionsState {
  final List<DoctorQuestionEntity> items;
  final DoctorQuestionsFilter selectedFilter;
  final bool isMutating;
  final bool isReordering;

  const DoctorQuestionsLoaded({
    required this.items,
    this.selectedFilter = DoctorQuestionsFilter.all,
    this.isMutating = false,
    this.isReordering = false,
  });

  List<DoctorQuestionEntity> get filteredItems {
    return switch (selectedFilter) {
      DoctorQuestionsFilter.all => items,
      DoctorQuestionsFilter.active =>
        items.where((q) => q.isActive).toList(),
      DoctorQuestionsFilter.inactive =>
        items.where((q) => !q.isActive).toList(),
    };
  }

  int get activeCount => items.where((q) => q.isActive).length;
  int get inactiveCount => items.where((q) => !q.isActive).length;

  DoctorQuestionsLoaded copyWith({
    List<DoctorQuestionEntity>? items,
    DoctorQuestionsFilter? selectedFilter,
    bool? isMutating,
    bool? isReordering,
  }) {
    return DoctorQuestionsLoaded(
      items: items ?? this.items,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isMutating: isMutating ?? this.isMutating,
      isReordering: isReordering ?? this.isReordering,
    );
  }

  @override
  List<Object?> get props => [
        items,
        selectedFilter,
        isMutating,
        isReordering,
      ];
}

class DoctorQuestionsEmpty extends DoctorQuestionsState {
  const DoctorQuestionsEmpty();
}

class DoctorQuestionsError extends DoctorQuestionsState {
  final Failure failure;

  const DoctorQuestionsError(this.failure);

  @override
  List<Object?> get props => [failure];
}
