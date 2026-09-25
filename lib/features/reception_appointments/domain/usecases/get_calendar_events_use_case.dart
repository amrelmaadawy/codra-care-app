import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment_calendar_day_entity.dart';
import '../entities/appointment_enums.dart';
import '../repositories/appointment_repository.dart';

class GetCalendarEventsUseCase {
  final AppointmentRepository repository;

  const GetCalendarEventsUseCase(this.repository);

  Future<Either<Failure, List<AppointmentCalendarDayEntity>>> call({
    required String month,
    int? doctorId,
    AppointmentStatus? status,
  }) {
    return repository.getCalendarEvents(
      month: month,
      doctorId: doctorId,
      status: status,
    );
  }
}
