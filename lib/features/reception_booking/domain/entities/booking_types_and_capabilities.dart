import 'package:equatable/equatable.dart';

class BookingTypeEntity extends Equatable {
  final String value;
  final String label;

  const BookingTypeEntity({required this.value, required this.label});

  @override
  List<Object?> get props => [value, label];
}

class BookingCapabilitiesEntity extends Equatable {
  final bool canCreatePatient;
  final bool canViewQuestions;
  final bool canAnswerQuestions;

  const BookingCapabilitiesEntity({
    required this.canCreatePatient,
    required this.canViewQuestions,
    required this.canAnswerQuestions,
  });

  @override
  List<Object?> get props => [
    canCreatePatient,
    canViewQuestions,
    canAnswerQuestions,
  ];
}
