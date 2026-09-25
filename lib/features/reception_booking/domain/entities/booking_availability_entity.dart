import 'package:equatable/equatable.dart';
import 'booking_slot_entity.dart';

class BookingAvailabilityEntity extends Equatable {
  final String scheduleMode;
  final bool requiresTime;
  final bool isWorking;
  final bool isOnLeave;
  final int? dailyLimit;
  final int bookedCount;
  final int? availableCount;
  final List<BookingSlotEntity> slots;
  final String? message;

  const BookingAvailabilityEntity({
    required this.scheduleMode,
    required this.requiresTime,
    required this.isWorking,
    required this.isOnLeave,
    this.dailyLimit,
    required this.bookedCount,
    this.availableCount,
    required this.slots,
    this.message,
  });

  bool get isAvailable => isWorking && !isOnLeave;

  @override
  List<Object?> get props => [
    scheduleMode,
    requiresTime,
    isWorking,
    isOnLeave,
    dailyLimit,
    bookedCount,
    availableCount,
    slots,
    message,
  ];
}
