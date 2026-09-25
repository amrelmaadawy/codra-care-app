import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/check_in_result_entity.dart';
import '../repositories/appointment_repository.dart';

class CheckInAppointmentUseCase {
  final AppointmentRepository repository;

  const CheckInAppointmentUseCase(this.repository);

  Future<Either<Failure, CheckInResultEntity>> call({
    required int appointmentId,
    String priority = 'normal',
    String? clientRequestId,
  }) {
    return repository.checkInAppointment(
      appointmentId: appointmentId,
      priority: priority,
      clientRequestId: clientRequestId,
    );
  }
}
