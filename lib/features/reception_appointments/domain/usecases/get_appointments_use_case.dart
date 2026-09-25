import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment_filters.dart';
import '../entities/appointments_page_entity.dart';
import '../repositories/appointment_repository.dart';

class GetAppointmentsUseCase {
  final AppointmentRepository repository;

  const GetAppointmentsUseCase(this.repository);

  Future<Either<Failure, AppointmentsPageEntity>> call({
    required AppointmentFilters filters,
    int page = 1,
    int perPage = 20,
  }) {
    return repository.getAppointments(
      filters: filters,
      page: page,
      perPage: perPage,
    );
  }
}
