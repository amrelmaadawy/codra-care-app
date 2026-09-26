import 'package:equatable/equatable.dart';
import 'booking_availability_entity.dart';
import 'booking_doctor_entity.dart';
import 'booking_patient_entity.dart';
import 'booking_service_entity.dart';

class FollowUpScheduleContextEntity extends Equatable {
  final int visitId;
  final String? visitNumber;
  final String? dueDate;
  final String instructions;
  final BookingPatientEntity patient;
  final BookingDoctorEntity doctor;
  final List<BookingDoctorEntity> allDoctors;
  final List<BookingServiceEntity> services;
  final int? defaultServiceId;
  final BookingAvailabilityEntity? availability;
  final bool canSchedule;

  const FollowUpScheduleContextEntity({
    required this.visitId,
    this.visitNumber,
    this.dueDate,
    required this.instructions,
    required this.patient,
    required this.doctor,
    required this.allDoctors,
    required this.services,
    this.defaultServiceId,
    this.availability,
    required this.canSchedule,
  });

  @override
  List<Object?> get props => [
        visitId,
        visitNumber,
        dueDate,
        instructions,
        patient,
        doctor,
        allDoctors,
        services,
        defaultServiceId,
        availability,
        canSchedule,
      ];
}
