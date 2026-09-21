import 'package:equatable/equatable.dart';

class DoctorQuestionEntity extends Equatable {
  final int id;
  final String questionText;
  final String questionType;
  final List<String> options;
  final bool isRequired;
  final String? lastAnswer;

  const DoctorQuestionEntity({
    required this.id,
    required this.questionText,
    required this.questionType,
    this.options = const [],
    this.isRequired = false,
    this.lastAnswer,
  });

  bool get isText => questionType == 'text';
  bool get isYesNo => questionType == 'yes_no';
  bool get isMultipleChoice => questionType == 'multiple_choice';

  @override
  List<Object?> get props => [
        id,
        questionText,
        questionType,
        options,
        isRequired,
        lastAnswer,
      ];
}
