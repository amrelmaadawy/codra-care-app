import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_notification_entity.dart';

abstract class DoctorNotificationsRepository {
  Future<Either<Failure, DoctorNotificationsEntity>> getNotifications();

  Future<Either<Failure, bool>> markAsRead({
    required NotificationType type,
    required dynamic id,
  });

  Future<Either<Failure, bool>> markAll();
}
