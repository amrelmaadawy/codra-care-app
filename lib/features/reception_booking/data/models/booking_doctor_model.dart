import '../../domain/entities/booking_doctor_entity.dart';

class BookingDoctorModel extends BookingDoctorEntity {
  const BookingDoctorModel({
    required super.id,
    required super.name,
    required super.specialization,
    required super.scheduleMode,
    required super.requiresTime,
    super.dailyLimit,
    super.defaultServiceId,
  });

  factory BookingDoctorModel.fromJson(Map<String, dynamic> json) {
    return BookingDoctorModel(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      specialization: (json['specialization'] ?? '') as String,
      scheduleMode: (json['schedule_mode'] ?? 'timed') as String,
      requiresTime: (json['requires_time'] ?? true) as bool,
      dailyLimit: json['daily_limit'] as int?,
      defaultServiceId: json['default_service_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialization': specialization,
    'schedule_mode': scheduleMode,
    'requires_time': requiresTime,
    'daily_limit': dailyLimit,
    'default_service_id': defaultServiceId,
  };
}
