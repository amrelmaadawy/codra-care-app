import '../../domain/entities/doctor_question_entity.dart';

class DoctorQuestionModel extends DoctorQuestionEntity {
  const DoctorQuestionModel({
    required super.id,
    required super.text,
    required super.type,
    super.options = const [],
    super.isRequired = false,
    super.isActive = true,
    super.sortOrder = 0,
  });

  factory DoctorQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    List<String> parsedOptions = const [];
    if (rawOptions is List) {
      parsedOptions = rawOptions
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    final rawType = (json['question_type'] ?? json['type'] ?? 'text').toString();
    final rawText = (json['question_text'] ?? json['text'] ?? '').toString();

    final rawIsRequired = json['is_required'];
    final bool isRequired = rawIsRequired is bool
        ? rawIsRequired
        : (rawIsRequired == 1 || rawIsRequired == '1');

    final rawIsActive = json['is_active'];
    final bool isActive = rawIsActive is bool
        ? rawIsActive
        : (rawIsActive == 1 || rawIsActive == '1' || rawIsActive == null);

    final rawSortOrder = json['sort_order'];
    final int sortOrder = rawSortOrder is int
        ? rawSortOrder
        : int.tryParse(rawSortOrder?.toString() ?? '') ?? 0;

    return DoctorQuestionModel(
      id: json['id'] as int? ?? 0,
      text: rawText,
      type: DoctorQuestionType.fromString(rawType),
      options: parsedOptions,
      isRequired: isRequired,
      isActive: isActive,
      sortOrder: sortOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': text,
      'question_type': type.toApiString(),
      'options': type == DoctorQuestionType.multipleChoice ? options : null,
      'is_required': isRequired,
      'is_active': isActive,
      'sort_order': sortOrder,
    };
  }
}
