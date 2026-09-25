import '../../domain/entities/booking_service_entity.dart';

class BookingServiceModel extends BookingServiceEntity {
  const BookingServiceModel({
    required super.id,
    required super.name,
    required super.price,
    required super.durationMinutes,
    required super.isPackage,
    super.totalSessions,
    super.validityDays,
  });

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) {
    return BookingServiceModel(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      durationMinutes: json['duration_minutes'] as int? ?? 15,
      isPackage: json['is_package'] as bool? ?? false,
      totalSessions: json['total_sessions'] as int?,
      validityDays: json['validity_days'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'duration_minutes': durationMinutes,
    'is_package': isPackage,
    'total_sessions': totalSessions,
    'validity_days': validityDays,
  };
}
