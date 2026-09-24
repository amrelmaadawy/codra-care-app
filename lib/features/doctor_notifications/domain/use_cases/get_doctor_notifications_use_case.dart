import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_notification_entity.dart';
import '../repositories/doctor_notifications_repository.dart';

class GetDoctorNotificationsUseCase {
  final DoctorNotificationsRepository _repository;

  const GetDoctorNotificationsUseCase(this._repository);

  Future<Either<Failure, DoctorNotificationsEntity>> call() =>
      _repository.getNotifications();
}
