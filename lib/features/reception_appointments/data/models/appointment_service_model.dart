import '../../domain/entities/appointment_service_entity.dart';

class AppointmentServiceModel extends AppointmentServiceEntity {
  const AppointmentServiceModel({
    required super.id,
    required super.name,
    required super.price,
    required super.durationMinutes,
    required super.isPackage,
  });

  factory AppointmentServiceModel.fromJson(Map<String, dynamic> json) {
    return AppointmentServiceModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 15,
      isPackage: (json['is_package'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration_minutes': durationMinutes,
      'is_package': isPackage,
    };
  }
}
