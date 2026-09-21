import 'package:equatable/equatable.dart';

class VisitPatientEntity extends Equatable {
  final int id;
  final String name;
  final String? code;
  final String? phone;
  final String? gender;
  final int? age;
  final String? bloodType;

  const VisitPatientEntity({
    required this.id,
    required this.name,
    this.code,
    this.phone,
    this.gender,
    this.age,
    this.bloodType,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        phone,
        gender,
        age,
        bloodType,
      ];
}
