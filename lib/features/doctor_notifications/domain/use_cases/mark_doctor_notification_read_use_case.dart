import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_notification_entity.dart';
import '../repositories/doctor_notifications_repository.dart';

class MarkDoctorNotificationReadUseCase {
  final DoctorNotificationsRepository _repository;

  const MarkDoctorNotificationReadUseCase(this._repository);

  Future<Either<Failure, bool>> call({
    required NotificationType type,
    required dynamic id,
  }) =>
      _repository.markAsRead(type: type, id: id);
}
