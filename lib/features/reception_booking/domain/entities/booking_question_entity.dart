import 'package:equatable/equatable.dart';

class BookingQuestionEntity extends Equatable {
  final int index;
  final String text;
  final String type; // 'text', 'choice', 'boolean'
  final List<String> options;
  final bool required;

  const BookingQuestionEntity({
    required this.index,
    required this.text,
    required this.type,
    required this.options,
    required this.required,
  });

  @override
  List<Object?> get props => [index, text, type, options, required];
}
