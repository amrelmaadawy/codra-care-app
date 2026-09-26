import 'package:equatable/equatable.dart';

enum FollowUpUrgency { overdue, today, upcoming }

class ReceptionFollowUpEntity extends Equatable {
  final int id;
  final int visitId;
  final String? visitNumber;
  final String? visitDate;
  final int patientId;
  final String patientName;
  final String patientPhone;
  final String? patientCode;
  final String? patientGender;
  final int? patientAge;
  final int doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final int? serviceId;
  final String? serviceName;
  final double? servicePrice;
  final double? serviceFollowupPrice;
  final int? followupDays;
  final String? dueDate;
  final FollowUpUrgency urgency;
  final int daysDelta;
  final String instructions;
  final bool canSchedule;

  const ReceptionFollowUpEntity({
    required this.id,
    required this.visitId,
    this.visitNumber,
    this.visitDate,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    this.patientCode,
    this.patientGender,
    this.patientAge,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    this.serviceId,
    this.serviceName,
    this.servicePrice,
    this.serviceFollowupPrice,
    this.followupDays,
    this.dueDate,
    required this.urgency,
    required this.daysDelta,
    required this.instructions,
    required this.canSchedule,
  });

  bool get isOverdue => urgency == FollowUpUrgency.overdue;
  bool get isToday => urgency == FollowUpUrgency.today;
  bool get isUpcoming => urgency == FollowUpUrgency.upcoming;

  @override
  List<Object?> get props => [
        id,
        visitId,
        visitNumber,
        visitDate,
        patientId,
        patientName,
        patientPhone,
        patientCode,
        patientGender,
        patientAge,
        doctorId,
        doctorName,
        doctorSpecialization,
        serviceId,
        serviceName,
        servicePrice,
        serviceFollowupPrice,
        followupDays,
        dueDate,
        urgency,
        daysDelta,
        instructions,
        canSchedule,
      ];
}
