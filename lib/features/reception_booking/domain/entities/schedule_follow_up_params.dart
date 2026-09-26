import 'package:equatable/equatable.dart';

class ScheduleFollowUpParams extends Equatable {
  final int visitId;
  final int doctorId;
  final int serviceId;
  final String appointmentDate;
  final String? appointmentTime;
  final String? notes;
  final String clientRequestId;

  const ScheduleFollowUpParams({
    required this.visitId,
    required this.doctorId,
    required this.serviceId,
    required this.appointmentDate,
    this.appointmentTime,
    this.notes,
    required this.clientRequestId,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'service_id': serviceId,
      'appointment_date': appointmentDate,
      if (appointmentTime != null && appointmentTime!.isNotEmpty)
        'appointment_time': appointmentTime,
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
      'client_request_id': clientRequestId,
    };
  }

  @override
  List<Object?> get props => [
        visitId,
        doctorId,
        serviceId,
        appointmentDate,
        appointmentTime,
        notes,
        clientRequestId,
      ];
}
