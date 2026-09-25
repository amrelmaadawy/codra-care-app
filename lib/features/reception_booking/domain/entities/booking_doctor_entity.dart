import 'package:equatable/equatable.dart';

class BookingDoctorEntity extends Equatable {
  final int id;
  final String name;
  final String specialization;
  final String scheduleMode; // 'timed' or 'queue'
  final bool requiresTime;
  final int? dailyLimit;
  final int? defaultServiceId;

  const BookingDoctorEntity({
    required this.id,
    required this.name,
    required this.specialization,
    required this.scheduleMode,
    required this.requiresTime,
    this.dailyLimit,
    this.defaultServiceId,
  });

  bool get isTimed => requiresTime || scheduleMode == 'timed';

  @override
  List<Object?> get props => [
    id,
    name,
    specialization,
    scheduleMode,
    requiresTime,
    dailyLimit,
    defaultServiceId,
  ];
}
