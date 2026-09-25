import 'package:equatable/equatable.dart';
import 'appointment_enums.dart';

class AppointmentFilters extends Equatable {
  final String date;
  final int? doctorId;
  final AppointmentStatus? status;

  const AppointmentFilters({required this.date, this.doctorId, this.status});

  AppointmentFilters copyWith({
    String? date,
    int? doctorId,
    bool clearDoctorId = false,
    AppointmentStatus? status,
    bool clearStatus = false,
  }) {
    return AppointmentFilters(
      date: date ?? this.date,
      doctorId: clearDoctorId ? null : (doctorId ?? this.doctorId),
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  @override
  List<Object?> get props => [date, doctorId, status];
}
