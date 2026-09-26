import '../../domain/entities/reception_follow_up_entity.dart';

class ReceptionFollowUpModel extends ReceptionFollowUpEntity {
  const ReceptionFollowUpModel({
    required super.id,
    required super.visitId,
    super.visitNumber,
    super.visitDate,
    required super.patientId,
    required super.patientName,
    required super.patientPhone,
    super.patientCode,
    super.patientGender,
    super.patientAge,
    required super.doctorId,
    required super.doctorName,
    required super.doctorSpecialization,
    super.serviceId,
    super.serviceName,
    super.servicePrice,
    super.serviceFollowupPrice,
    super.followupDays,
    super.dueDate,
    required super.urgency,
    required super.daysDelta,
    required super.instructions,
    required super.canSchedule,
  });

  factory ReceptionFollowUpModel.fromJson(Map<String, dynamic> json) {
    final patientMap = json['patient'] as Map<String, dynamic>? ?? {};
    final doctorMap = json['doctor'] as Map<String, dynamic>? ?? {};
    final serviceMap = json['service'] as Map<String, dynamic>? ?? {};
    final capabilitiesMap =
        json['capabilities'] as Map<String, dynamic>? ?? {};

    final urgencyStr = json['urgency'] as String? ?? 'upcoming';
    final urgency = switch (urgencyStr) {
      'overdue' => FollowUpUrgency.overdue,
      'today' => FollowUpUrgency.today,
      _ => FollowUpUrgency.upcoming,
    };

    return ReceptionFollowUpModel(
      id: json['id'] as int? ?? 0,
      visitId: json['visit_id'] as int? ?? json['id'] as int? ?? 0,
      visitNumber: json['visit_number'] as String?,
      visitDate: json['visit_date'] as String?,
      patientId: patientMap['id'] as int? ?? 0,
      patientName: patientMap['full_name'] as String? ?? '',
      patientPhone: patientMap['phone'] as String? ?? '',
      patientCode: patientMap['patient_code'] as String?,
      patientGender: patientMap['gender'] as String?,
      patientAge: patientMap['age'] as int?,
      doctorId: doctorMap['id'] as int? ?? 0,
      doctorName: doctorMap['name'] as String? ?? '',
      doctorSpecialization: doctorMap['specialization'] as String? ?? '',
      serviceId: serviceMap['id'] as int?,
      serviceName: serviceMap['name'] as String?,
      servicePrice: (serviceMap['price'] as num?)?.toDouble(),
      serviceFollowupPrice:
          (serviceMap['followup_price'] as num?)?.toDouble(),
      followupDays: json['followup_days'] as int?,
      dueDate: json['due_date'] as String?,
      urgency: urgency,
      daysDelta: json['days_delta'] as int? ?? 0,
      instructions: json['instructions'] as String? ?? '',
      canSchedule: capabilitiesMap['can_schedule'] as bool? ?? false,
    );
  }
}
