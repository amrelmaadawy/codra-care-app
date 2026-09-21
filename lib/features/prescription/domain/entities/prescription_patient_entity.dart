import 'package:equatable/equatable.dart';

class PrescriptionPatientEntity extends Equatable {
  final int id;
  final String fullName;
  final String? phone;
  final String? patientCode;

  const PrescriptionPatientEntity({
    required this.id,
    required this.fullName,
    this.phone,
    this.patientCode,
  });

  @override
  List<Object?> get props => [id, fullName, phone, patientCode];
}
