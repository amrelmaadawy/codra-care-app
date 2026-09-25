import '../../domain/entities/booking_question_entity.dart';

class BookingQuestionModel extends BookingQuestionEntity {
  const BookingQuestionModel({
    required super.index,
    required super.text,
    required super.type,
    required super.options,
    required super.required,
  });

  factory BookingQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List<dynamic>? ?? [];
    return BookingQuestionModel(
      index: json['index'] as int? ?? 0,
      text: (json['text'] ?? '') as String,
      type: (json['type'] ?? 'text') as String,
      options: rawOptions.map((e) => e.toString()).toList(),
      required: json['required'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'index': index,
    'text': text,
    'type': type,
    'options': options,
    'required': required,
  };
}
