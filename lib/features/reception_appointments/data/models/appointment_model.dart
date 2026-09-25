import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_enums.dart';
import 'appointment_doctor_model.dart';
import 'appointment_patient_model.dart';
import 'appointment_service_model.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.appointmentNumber,
    required super.patient,
    required super.doctor,
    super.service,
    required super.appointmentDate,
    super.appointmentTime,
    super.startTime,
    super.endTime,
    super.queuePosition,
    required super.bookingType,
    required super.bookingMode,
    required super.status,
    required super.servicePrice,
    super.notes,
    super.cancellationReason,
    super.totalSessions,
    super.completedSessions,
    super.remainingSessions,
    required super.canCancel,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final patientJson = json['patient'] as Map<String, dynamic>? ?? {};
    final doctorJson = json['doctor'] as Map<String, dynamic>? ?? {};
    final serviceJson = json['service'] as Map<String, dynamic>?;
    final capabilities = json['capabilities'] as Map<String, dynamic>? ?? {};

    return AppointmentModel(
      id: (json['id'] as num).toInt(),
      appointmentNumber: (json['appointment_number'] as String?) ?? '',
      patient: AppointmentPatientModel.fromJson(patientJson),
      doctor: AppointmentDoctorModel.fromJson(doctorJson),
      service: serviceJson != null
          ? AppointmentServiceModel.fromJson(serviceJson)
          : null,
      appointmentDate: (json['appointment_date'] as String?) ?? '',
      appointmentTime: json['appointment_time'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      queuePosition: (json['queue_position'] as num?)?.toInt(),
      bookingType: BookingType.fromString(json['booking_type'] as String?),
      bookingMode: AppointmentBookingMode.fromString(
        json['booking_mode'] as String?,
      ),
      status: AppointmentStatus.fromString(json['status'] as String?),
      servicePrice: (json['service_price'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      totalSessions: (json['total_sessions'] as num?)?.toInt(),
      completedSessions: (json['completed_sessions'] as num?)?.toInt(),
      remainingSessions: (json['remaining_sessions'] as num?)?.toInt(),
      canCancel: (capabilities['can_cancel'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_number': appointmentNumber,
      'patient': (patient as AppointmentPatientModel).toJson(),
      'doctor': (doctor as AppointmentDoctorModel).toJson(),
      'service': (service as AppointmentServiceModel?)?.toJson(),
      'appointment_date': appointmentDate,
      'appointment_time': appointmentTime,
      'start_time': startTime,
      'end_time': endTime,
      'queue_position': queuePosition,
      'booking_type': bookingType.toApiValue(),
      'booking_mode': bookingMode.name,
      'status': status.toApiValue(),
      'service_price': servicePrice,
      'notes': notes,
      'cancellation_reason': cancellationReason,
      'total_sessions': totalSessions,
      'completed_sessions': completedSessions,
      'remaining_sessions': remainingSessions,
      'capabilities': {'can_cancel': canCancel},
    };
  }
}
