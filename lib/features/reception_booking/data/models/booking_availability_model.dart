import '../../domain/entities/booking_availability_entity.dart';
import 'booking_slot_model.dart';

class BookingAvailabilityModel extends BookingAvailabilityEntity {
  const BookingAvailabilityModel({
    required super.scheduleMode,
    required super.requiresTime,
    required super.isWorking,
    required super.isOnLeave,
    super.dailyLimit,
    required super.bookedCount,
    super.availableCount,
    required super.slots,
    super.message,
  });

  factory BookingAvailabilityModel.fromJson(Map<String, dynamic> json) {
    final rawSlots = json['slots'] as List<dynamic>? ?? [];
    final slots = rawSlots
        .map((s) => BookingSlotModel.fromJson(s as Map<String, dynamic>))
        .toList();

    return BookingAvailabilityModel(
      scheduleMode: (json['schedule_mode'] ?? 'timed') as String,
      requiresTime: (json['requires_time'] ?? false) as bool,
      isWorking: (json['is_working'] ?? true) as bool,
      isOnLeave: (json['is_on_leave'] ?? false) as bool,
      dailyLimit: json['daily_limit'] as int?,
      bookedCount: json['booked_count'] as int? ?? 0,
      availableCount: json['available_count'] as int?,
      slots: slots,
      message: json['message'] as String?,
    );
  }
}
