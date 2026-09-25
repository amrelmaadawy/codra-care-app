import 'package:equatable/equatable.dart';

class BookingServiceEntity extends Equatable {
  final int id;
  final String name;
  final double price;
  final int durationMinutes;
  final bool isPackage;
  final int? totalSessions;
  final int? validityDays;

  const BookingServiceEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMinutes,
    required this.isPackage,
    this.totalSessions,
    this.validityDays,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    durationMinutes,
    isPackage,
    totalSessions,
    validityDays,
  ];
}
