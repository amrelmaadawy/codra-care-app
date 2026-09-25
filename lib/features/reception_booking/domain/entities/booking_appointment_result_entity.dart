import 'package:equatable/equatable.dart';

class BookingAppointmentResultEntity extends Equatable {
  final int id;
  final String status;
  final String date;
  final String? time;
  final String patientName;
  final String doctorName;
  final String serviceName;

  const BookingAppointmentResultEntity({
    required this.id,
    required this.status,
    required this.date,
    this.time,
    required this.patientName,
    required this.doctorName,
    required this.serviceName,
  });

  @override
  List<Object?> get props => [
    id,
    status,
    date,
    time,
    patientName,
    doctorName,
    serviceName,
  ];
}
