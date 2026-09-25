import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment_calendar_day_entity.dart';
import '../entities/appointment_entity.dart';
import '../entities/appointment_enums.dart';
import '../entities/appointment_filters.dart';
import '../entities/appointments_page_entity.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, AppointmentsPageEntity>> getAppointments({
    required AppointmentFilters filters,
    int page = 1,
    int perPage = 20,
  });

  Future<Either<Failure, List<AppointmentCalendarDayEntity>>>
  getCalendarEvents({
    required String month,
    int? doctorId,
    AppointmentStatus? status,
  });

  Future<Either<Failure, AppointmentEntity>> cancelAppointment({
    required int appointmentId,
    required String reason,
  });
}
