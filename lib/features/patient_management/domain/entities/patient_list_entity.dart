import 'package:equatable/equatable.dart';

class PatientListEntity extends Equatable {
  final int id;
  final String code;
  final String name;
  final String? phone;
  final String? gender;
  final int? age;
  final String? lastVisitDate;

  const PatientListEntity({
    required this.id,
    required this.code,
    required this.name,
    this.phone,
    this.gender,
    this.age,
    this.lastVisitDate,
  });

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    phone,
    gender,
    age,
    lastVisitDate,
  ];
}
