import '../../domain/entities/follow_up_schedule_context_entity.dart';
import 'booking_availability_model.dart';
import 'booking_doctor_model.dart';
import 'booking_patient_model.dart';
import 'booking_service_model.dart';

class FollowUpScheduleContextModel extends FollowUpScheduleContextEntity {
  const FollowUpScheduleContextModel({
    required super.visitId,
    super.visitNumber,
    super.dueDate,
    required super.instructions,
    required super.patient,
    required super.doctor,
    required super.allDoctors,
    required super.services,
    super.defaultServiceId,
    super.availability,
    required super.canSchedule,
  });

  factory FollowUpScheduleContextModel.fromJson(Map<String, dynamic> json) {
    final visitMap = json['visit'] as Map<String, dynamic>? ?? {};
    final patientMap = visitMap['patient'] as Map<String, dynamic>? ?? {};
    final doctorMap = json['doctor'] as Map<String, dynamic>? ?? {};
    final rawAllDocs = json['all_doctors'] as List<dynamic>? ?? [];
    final rawServices = json['services'] as List<dynamic>? ?? [];
    final capabilitiesMap = json['capabilities'] as Map<String, dynamic>? ?? {};

    final patient = BookingPatientModel.fromJson(patientMap);
    final doctor = BookingDoctorModel.fromJson(doctorMap);

    final allDoctors = rawAllDocs
        .map((d) => BookingDoctorModel.fromJson(d as Map<String, dynamic>))
        .toList();

    final services = rawServices.map((s) {
      final map = Map<String, dynamic>.from(s as Map);
      if (map['followup_price'] != null) {
        map['price'] = map['followup_price'];
      }
      return BookingServiceModel.fromJson(map);
    }).toList();

    BookingAvailabilityModel? availability;
    if (json['availability'] != null && json['availability'] is Map) {
      availability = BookingAvailabilityModel.fromJson(
        json['availability'] as Map<String, dynamic>,
      );
    }

    return FollowUpScheduleContextModel(
      visitId: visitMap['id'] as int? ?? 0,
      visitNumber: visitMap['visit_number'] as String?,
      dueDate: visitMap['followup_due_date'] as String?,
      instructions: (visitMap['instructions'] ?? '') as String,
      patient: patient,
      doctor: doctor,
      allDoctors: allDoctors.isNotEmpty ? allDoctors : [doctor],
      services: services,
      defaultServiceId: json['default_service_id'] as int?,
      availability: availability,
      canSchedule: capabilitiesMap['can_schedule'] as bool? ?? true,
    );
  }
}
