import 'package:equatable/equatable.dart';
import '../../domain/entities/examination_entity.dart';

sealed class ExaminationState extends Equatable {
  const ExaminationState();

  @override
  List<Object?> get props => [];
}

final class ExaminationInitial extends ExaminationState {
  const ExaminationInitial();
}

final class ExaminationLoading extends ExaminationState {
  const ExaminationLoading();
}

final class ExaminationLoaded extends ExaminationState {
  final ExaminationEntity visit;
  final Set<String> savingSections;
  final Set<String> savedSections;
  final String? errorMessage;
  final String? successMessage;
  final bool isUploading;
  final bool isCompleting;
  final bool isCompleted;
  final Map<String, dynamic>? fieldErrors;

  const ExaminationLoaded({
    required this.visit,
    this.savingSections = const {},
    this.savedSections = const {},
    this.errorMessage,
    this.successMessage,
    this.isUploading = false,
    this.isCompleting = false,
    this.isCompleted = false,
    this.fieldErrors,
  });

  bool isSectionSaving(String section) => savingSections.contains(section);
  bool isSectionSaved(String section) => savedSections.contains(section);
  bool get isAnySectionSaving => savingSections.isNotEmpty;
  bool get isAnySectionSaved => savedSections.isNotEmpty && savingSections.isEmpty;

  ExaminationLoaded copyWith({
    ExaminationEntity? visit,
    Set<String>? savingSections,
    Set<String>? savedSections,
    String? errorMessage,
    String? successMessage,
    bool? isUploading,
    bool? isCompleting,
    bool? isCompleted,
    Map<String, dynamic>? fieldErrors,
    bool clearErrors = false,
  }) {
    return ExaminationLoaded(
      visit: visit ?? this.visit,
      savingSections: savingSections ?? this.savingSections,
      savedSections: savedSections ?? this.savedSections,
      errorMessage: clearErrors ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearErrors ? null : (successMessage ?? this.successMessage),
      isUploading: isUploading ?? this.isUploading,
      isCompleting: isCompleting ?? this.isCompleting,
      isCompleted: isCompleted ?? this.isCompleted,
      fieldErrors: clearErrors ? null : (fieldErrors ?? this.fieldErrors),
    );
  }

  @override
  List<Object?> get props => [
        visit,
        savingSections,
        savedSections,
        errorMessage,
        successMessage,
        isUploading,
        isCompleting,
        isCompleted,
        fieldErrors,
      ];
}

final class ExaminationError extends ExaminationState {
  final String message;

  const ExaminationError(this.message);

  @override
  List<Object?> get props => [message];
}
