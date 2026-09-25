import 'package:equatable/equatable.dart';

class AppointmentDoctorEntity extends Equatable {
  final int id;
  final String name;
  final String? specialization;

  const AppointmentDoctorEntity({
    required this.id,
    required this.name,
    this.specialization,
  });

  @override
  List<Object?> get props => [id, name, specialization];
}
