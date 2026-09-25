import '../../domain/entities/booking_slot_entity.dart';

class BookingSlotModel extends BookingSlotEntity {
  const BookingSlotModel({
    required super.value,
    required super.label,
    required super.end,
    required super.isBooked,
  });

  factory BookingSlotModel.fromJson(Map<String, dynamic> json) {
    return BookingSlotModel(
      value: (json['value'] ?? '') as String,
      label: (json['label'] ?? '') as String,
      end: (json['end'] ?? '') as String,
      isBooked: json['is_booked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'value': value,
    'label': label,
    'end': end,
    'is_booked': isBooked,
  };
}
