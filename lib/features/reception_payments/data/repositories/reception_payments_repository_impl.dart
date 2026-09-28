import 'package:dartz/dartz.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/financial_snapshot_entity.dart';
import '../../domain/entities/payment_action_result_entity.dart';
import '../../domain/entities/service_option_entity.dart';
import '../../domain/repositories/reception_payments_repository.dart';
import '../data_sources/reception_payments_remote_data_source.dart';

class ReceptionPaymentsRepositoryImpl implements ReceptionPaymentsRepository {
  final ReceptionPaymentsRemoteDataSource _remoteDataSource;

  const ReceptionPaymentsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, FinancialSnapshotEntity>> getFinancialSnapshot(
    int appointmentId,
  ) async {
    try {
      final model = await _remoteDataSource.getFinancialSnapshot(appointmentId);
      return Right(model);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaymentActionResultEntity>> addPayments({
    required int appointmentId,
    required int expectedFinancialVersion,
    required List<Map<String, dynamic>> payments,
    required String clientRequestId,
  }) async {
    try {
      final model = await _remoteDataSource.addPayments(
        appointmentId: appointmentId,
        expectedFinancialVersion: expectedFinancialVersion,
        payments: payments,
        clientRequestId: clientRequestId,
      );
      return Right(model);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaymentActionResultEntity>> addRefund({
    required int appointmentId,
    required int expectedFinancialVersion,
    required String amount,
    String? reason,
    int? specificPaymentTransactionId,
    required String clientRequestId,
  }) async {
    try {
      final model = await _remoteDataSource.addRefund(
        appointmentId: appointmentId,
        expectedFinancialVersion: expectedFinancialVersion,
        amount: amount,
        reason: reason,
        specificPaymentTransactionId: specificPaymentTransactionId,
        clientRequestId: clientRequestId,
      );
      return Right(model);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaymentActionResultEntity>> addDiscount({
    required int appointmentId,
    required int expectedFinancialVersion,
    required String amount,
    required String reason,
    required String clientRequestId,
  }) async {
    try {
      final model = await _remoteDataSource.addDiscount(
        appointmentId: appointmentId,
        expectedFinancialVersion: expectedFinancialVersion,
        amount: amount,
        reason: reason,
        clientRequestId: clientRequestId,
      );
      return Right(model);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaymentActionResultEntity>> addService({
    required int appointmentId,
    required int expectedFinancialVersion,
    required int serviceId,
    int? quantity,
    required String clientRequestId,
  }) async {
    try {
      final model = await _remoteDataSource.addService(
        appointmentId: appointmentId,
        expectedFinancialVersion: expectedFinancialVersion,
        serviceId: serviceId,
        quantity: quantity,
        clientRequestId: clientRequestId,
      );
      return Right(model);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ServiceOptionEntity>>> getServiceOptions(
    int appointmentId, {
    String? search,
    int? page,
  }) async {
    try {
      final list = await _remoteDataSource.getServiceOptions(
        appointmentId,
        search: search,
        page: page,
      );
      return Right(list);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getVoucherPreview(
    int appointmentId,
    int voucherId,
  ) async {
    try {
      final preview = await _remoteDataSource.getVoucherPreview(
        appointmentId,
        voucherId,
      );
      return Right(preview);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }
}
