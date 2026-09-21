import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_queue_entity.dart';

abstract interface class DoctorQueueRepository {
  Future<Either<Failure, DoctorQueueEntity>> getQueue();
  Future<Either<Failure, void>> callPatient(int id);
  Future<Either<Failure, void>> completePatient(int id);
  Future<Either<Failure, void>> cancelPatient(int id);
}
