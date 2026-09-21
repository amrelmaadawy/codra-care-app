import 'package:equatable/equatable.dart';

class PatientSummaryEntity extends Equatable {
  final int id;
  final String name;
  final String code;
  final String? phone;
  final String? gender;
  final String? genderLabel;
  final int? age;
  final int totalVisits;
  final String? lastVisitDate;
  final String? lastVisitDateHuman;

  const PatientSummaryEntity({
    required this.id,
    required this.name,
    required this.code,
    this.phone,
    this.gender,
    this.genderLabel,
    this.age,
    required this.totalVisits,
    this.lastVisitDate,
    this.lastVisitDateHuman,
  });

  bool get isFemale => gender == 'female';
  bool get isMale => gender == 'male';

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    phone,
    gender,
    genderLabel,
    age,
    totalVisits,
    lastVisitDate,
    lastVisitDateHuman,
  ];
}
