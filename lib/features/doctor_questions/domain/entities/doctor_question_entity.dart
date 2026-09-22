import 'package:equatable/equatable.dart';

enum DoctorQuestionType {
  text,
  yesNo,
  multipleChoice;

  static DoctorQuestionType fromString(String value) {
    return switch (value) {
      'yes_no' => DoctorQuestionType.yesNo,
      'multiple_choice' => DoctorQuestionType.multipleChoice,
      _ => DoctorQuestionType.text,
    };
  }

  String toApiString() => switch (this) {
    DoctorQuestionType.text => 'text',
    DoctorQuestionType.yesNo => 'yes_no',
    DoctorQuestionType.multipleChoice => 'multiple_choice',
  };
}

class DoctorQuestionEntity extends Equatable {
  final int id;
  final String text;
  final DoctorQuestionType type;
  final List<String> options;
  final bool isRequired;
  final bool isActive;
  final int sortOrder;

  const DoctorQuestionEntity({
    required this.id,
    required this.text,
    required this.type,
    this.options = const [],
    this.isRequired = false,
    this.isActive = true,
    this.sortOrder = 0,
  });

  bool get hasOptions =>
      type == DoctorQuestionType.multipleChoice && options.isNotEmpty;

  DoctorQuestionEntity copyWith({
    int? id,
    String? text,
    DoctorQuestionType? type,
    List<String>? options,
    bool? isRequired,
    bool? isActive,
    int? sortOrder,
  }) {
    return DoctorQuestionEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      options: options ?? this.options,
      isRequired: isRequired ?? this.isRequired,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        type,
        options,
        isRequired,
        isActive,
        sortOrder,
      ];
}
