import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class CancelAppointmentUseCase {
  final AppointmentRepository repository;

  const CancelAppointmentUseCase(this.repository);

  Future<Either<Failure, AppointmentEntity>> call({
    required int appointmentId,
    required String reason,
  }) {
    return repository.cancelAppointment(
      appointmentId: appointmentId,
      reason: reason,
    );
  }
}
