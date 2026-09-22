import '../../domain/entities/doctor_leave_day_entity.dart';

class DoctorLeaveDayModel extends DoctorLeaveDayEntity {
  const DoctorLeaveDayModel({
    required super.id,
    required super.leaveDate,
    super.formattedDate,
    super.dayName,
    super.reason,
    super.notifiedReception = true,
    super.createdAt,
  });

  factory DoctorLeaveDayModel.fromJson(Map<String, dynamic> json) {
    return DoctorLeaveDayModel(
      id: json['id'] as int? ?? 0,
      leaveDate: json['leave_date'] as String? ?? '',
      formattedDate: json['formatted_date'] as String?,
      dayName: json['day_name'] as String?,
      reason: json['reason'] as String?,
      notifiedReception: json['notified_reception'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leave_date': leaveDate,
      'formatted_date': formattedDate,
      'day_name': dayName,
      'reason': reason,
      'notified_reception': notifiedReception,
      'created_at': createdAt,
    };
  }
}
