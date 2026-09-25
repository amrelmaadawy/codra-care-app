import 'package:dartz/dartz.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/appointment_calendar_day_entity.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_enums.dart';
import '../../domain/entities/appointment_filters.dart';
import '../../domain/entities/appointments_page_entity.dart';
import '../../domain/entities/check_in_result_entity.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_remote_data_source.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource _remoteDataSource;

  const AppointmentRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AppointmentsPageEntity>> getAppointments({
    required AppointmentFilters filters,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final model = await _remoteDataSource.getAppointments(
        filters: filters,
        page: page,
        perPage: perPage,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentCalendarDayEntity>>>
  getCalendarEvents({
    required String month,
    int? doctorId,
    AppointmentStatus? status,
  }) async {
    try {
      final models = await _remoteDataSource.getCalendarEvents(
        month: month,
        doctorId: doctorId,
        status: status,
      );
      return Right(models);
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> cancelAppointment({
    required int appointmentId,
    required String reason,
  }) async {
    try {
      final model = await _remoteDataSource.cancelAppointment(
        appointmentId: appointmentId,
        reason: reason,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, CheckInResultEntity>> checkInAppointment({
    required int appointmentId,
    String priority = 'normal',
    String? clientRequestId,
  }) async {
    try {
      final model = await _remoteDataSource.checkInAppointment(
        appointmentId: appointmentId,
        priority: priority,
        clientRequestId: clientRequestId,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  Failure _mapException(dynamic e) => FailureMapper.mapExceptionToFailure(e);
}
