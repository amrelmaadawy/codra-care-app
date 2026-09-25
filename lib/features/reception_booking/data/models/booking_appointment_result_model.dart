import '../../domain/entities/booking_appointment_result_entity.dart';

class BookingAppointmentResultModel extends BookingAppointmentResultEntity {
  const BookingAppointmentResultModel({
    required super.id,
    required super.status,
    required super.date,
    super.time,
    required super.patientName,
    required super.doctorName,
    required super.serviceName,
  });

  factory BookingAppointmentResultModel.fromJson(Map<String, dynamic> json) {
    final patientMap = json['patient'] as Map<String, dynamic>? ?? {};
    final doctorMap = json['doctor'] as Map<String, dynamic>? ?? {};
    final serviceMap = json['service'] as Map<String, dynamic>? ?? {};

    return BookingAppointmentResultModel(
      id: json['id'] as int,
      status: (json['status'] ?? 'scheduled') as String,
      date: (json['appointment_date'] ?? '') as String,
      time: json['start_time'] as String?,
      patientName: (patientMap['name'] ?? '') as String,
      doctorName: (doctorMap['name'] ?? '') as String,
      serviceName: (serviceMap['name'] ?? '') as String,
    );
  }
}
