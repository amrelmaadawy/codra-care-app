import 'package:equatable/equatable.dart';
import 'appointment_doctor_entity.dart';
import 'appointment_enums.dart';
import 'appointment_patient_entity.dart';
import 'appointment_service_entity.dart';

class AppointmentEntity extends Equatable {
  final int id;
  final String appointmentNumber;
  final AppointmentPatientEntity patient;
  final AppointmentDoctorEntity doctor;
  final AppointmentServiceEntity? service;
  final String appointmentDate;
  final String? appointmentTime;
  final String? startTime;
  final String? endTime;
  final int? queuePosition;
  final BookingType bookingType;
  final AppointmentBookingMode bookingMode;
  final AppointmentStatus status;
  final double servicePrice;
  final String? notes;
  final String? cancellationReason;
  final int? totalSessions;
  final int? completedSessions;
  final int? remainingSessions;
  final bool canCancel;

  const AppointmentEntity({
    required this.id,
    required this.appointmentNumber,
    required this.patient,
    required this.doctor,
    this.service,
    required this.appointmentDate,
    this.appointmentTime,
    this.startTime,
    this.endTime,
    this.queuePosition,
    required this.bookingType,
    required this.bookingMode,
    required this.status,
    required this.servicePrice,
    this.notes,
    this.cancellationReason,
    this.totalSessions,
    this.completedSessions,
    this.remainingSessions,
    required this.canCancel,
  });

  bool get isPackage => (totalSessions ?? 0) > 0;

  @override
  List<Object?> get props => [
    id,
    appointmentNumber,
    patient,
    doctor,
    service,
    appointmentDate,
    appointmentTime,
    startTime,
    endTime,
    queuePosition,
    bookingType,
    bookingMode,
    status,
    servicePrice,
    notes,
    cancellationReason,
    totalSessions,
    completedSessions,
    remainingSessions,
    canCancel,
  ];
}
