import 'package:equatable/equatable.dart';

class DoctorVisitReportEntity extends Equatable {
  final int id;
  final String visitNumber;
  final int patientId;
  final String patientName;
  final String patientPhone;
  final String serviceName;
  final double servicePrice;
  final double doctorEarning;
  final String? visitDate;
  final String status;

  const DoctorVisitReportEntity({
    required this.id,
    required this.visitNumber,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    required this.serviceName,
    required this.servicePrice,
    required this.doctorEarning,
    this.visitDate,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        visitNumber,
        patientId,
        patientName,
        patientPhone,
        serviceName,
        servicePrice,
        doctorEarning,
        visitDate,
        status,
      ];
}
