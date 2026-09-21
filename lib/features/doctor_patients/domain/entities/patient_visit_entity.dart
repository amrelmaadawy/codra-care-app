import 'package:equatable/equatable.dart';

class PatientVisitEntity extends Equatable {
  final int id;
  final String? visitNumber;
  final String? visitDate;
  final String? status;
  final String? statusLabel;
  final String? chiefComplaint;
  final String? diagnosis;
  final String? notes;
  final String? serviceName;
  final int prescriptionsCount;

  const PatientVisitEntity({
    required this.id,
    this.visitNumber,
    this.visitDate,
    this.status,
    this.statusLabel,
    this.chiefComplaint,
    this.diagnosis,
    this.notes,
    this.serviceName,
    required this.prescriptionsCount,
  });

  bool get isCompleted => status == 'completed';

  @override
  List<Object?> get props => [
    id,
    visitNumber,
    visitDate,
    status,
    statusLabel,
    chiefComplaint,
    diagnosis,
    notes,
    serviceName,
    prescriptionsCount,
  ];
}
