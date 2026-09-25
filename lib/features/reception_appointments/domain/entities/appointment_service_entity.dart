import 'package:equatable/equatable.dart';

class AppointmentServiceEntity extends Equatable {
  final int id;
  final String name;
  final double price;
  final int durationMinutes;
  final bool isPackage;

  const AppointmentServiceEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMinutes,
    required this.isPackage,
  });

  @override
  List<Object?> get props => [id, name, price, durationMinutes, isPackage];
}
