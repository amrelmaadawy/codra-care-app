import 'package:equatable/equatable.dart';

class BookingSlotEntity extends Equatable {
  final String value; // e.g. "10:00:00"
  final String label; // e.g. "10:00 ص"
  final String end; // e.g. "10:15:00"
  final bool isBooked;

  const BookingSlotEntity({
    required this.value,
    required this.label,
    required this.end,
    required this.isBooked,
  });

  @override
  List<Object?> get props => [value, label, end, isBooked];
}
