import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/doctor_notifications_repository.dart';

class MarkAllDoctorNotificationsUseCase {
  final DoctorNotificationsRepository _repository;

  const MarkAllDoctorNotificationsUseCase(this._repository);

  Future<Either<Failure, bool>> call() => _repository.markAll();
}
