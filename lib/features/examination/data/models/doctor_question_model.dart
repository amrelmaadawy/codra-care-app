import '../../domain/entities/doctor_question_entity.dart';

class DoctorQuestionModel extends DoctorQuestionEntity {
  const DoctorQuestionModel({
    required super.id,
    required super.questionText,
    required super.questionType,
    super.options,
    super.isRequired,
    super.lastAnswer,
  });

  factory DoctorQuestionModel.fromJson(Map<String, dynamic> json) {
    List<String> optionsList = [];
    if (json['options'] != null) {
      if (json['options'] is List) {
        optionsList = (json['options'] as List)
            .map((e) => e.toString())
            .toList();
      }
    }

    final rawType = json['question_type'] ?? json['type'] ?? 'text';
    final typeStr = rawType is Map ? rawType['value'] : rawType.toString();

    final isReq = json['is_required'] == true ||
        json['is_required'] == 1 ||
        json['is_required'] == '1';

    return DoctorQuestionModel(
      id: json['id'] as int,
      questionText: json['question_text'] as String? ?? json['text'] as String? ?? '',
      questionType: typeStr,
      options: optionsList,
      isRequired: isReq,
      lastAnswer: json['last_answer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'question_type': questionType,
      'options': options,
      'is_required': isRequired,
      'last_answer': lastAnswer,
    };
  }
}
