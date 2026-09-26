import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/booking_appointment_result_entity.dart';
import '../../domain/entities/booking_form_context_entity.dart';
import '../../domain/entities/booking_patient_entity.dart';
import '../../domain/entities/create_appointment_params.dart';
import '../../domain/entities/follow_up_schedule_context_entity.dart';
import '../../domain/entities/schedule_follow_up_params.dart';
import '../../domain/entities/walk_in_params.dart';
import '../../domain/entities/walk_in_result_entity.dart';
import '../../domain/repositories/reception_booking_repository.dart';
import '../datasources/reception_booking_remote_data_source.dart';

class ReceptionBookingRepositoryImpl implements ReceptionBookingRepository {
  final ReceptionBookingRemoteDataSource remoteDataSource;

  const ReceptionBookingRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, BookingFormContextEntity>> getFormContext({
    int? doctorId,
    String? date,
  }) async {
    try {
      final result = await remoteDataSource.getFormContext(
        doctorId: doctorId,
        date: date,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingPatientEntity>>> searchPatients(
    String query,
  ) async {
    try {
      final result = await remoteDataSource.searchPatients(query);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingAppointmentResultEntity>> createAppointment(
    CreateAppointmentParams params,
  ) async {
    try {
      final result = await remoteDataSource.createAppointment(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WalkInResultEntity>> createWalkIn(
    WalkInParams params,
  ) async {
    try {
      final result = await remoteDataSource.createWalkIn(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FollowUpScheduleContextEntity>>
      getFollowUpScheduleContext(int visitId) async {
    try {
      final result = await remoteDataSource.getFollowUpScheduleContext(visitId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingAppointmentResultEntity>> scheduleFollowUp(
    ScheduleFollowUpParams params,
  ) async {
    try {
      final result = await remoteDataSource.scheduleFollowUp(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
