import 'package:equatable/equatable.dart';

class AppointmentPatientEntity extends Equatable {
  final int id;
  final String? patientCode;
  final String fullName;
  final String? phone;
  final String? gender;
  final int? age;

  const AppointmentPatientEntity({
    required this.id,
    this.patientCode,
    required this.fullName,
    this.phone,
    this.gender,
    this.age,
  });

  String get name => fullName;

  @override
  List<Object?> get props => [id, patientCode, fullName, phone, gender, age];
}
