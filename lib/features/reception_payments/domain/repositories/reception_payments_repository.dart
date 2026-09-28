import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/financial_snapshot_entity.dart';
import '../entities/payment_action_result_entity.dart';
import '../entities/service_option_entity.dart';

abstract class ReceptionPaymentsRepository {
  Future<Either<Failure, FinancialSnapshotEntity>> getFinancialSnapshot(
    int appointmentId,
  );

  Future<Either<Failure, PaymentActionResultEntity>> addPayments({
    required int appointmentId,
    required int expectedFinancialVersion,
    required List<Map<String, dynamic>> payments,
    required String clientRequestId,
  });

  Future<Either<Failure, PaymentActionResultEntity>> addRefund({
    required int appointmentId,
    required int expectedFinancialVersion,
    required String amount,
    String? reason,
    int? specificPaymentTransactionId,
    required String clientRequestId,
  });

  Future<Either<Failure, PaymentActionResultEntity>> addDiscount({
    required int appointmentId,
    required int expectedFinancialVersion,
    required String amount,
    required String reason,
    required String clientRequestId,
  });

  Future<Either<Failure, PaymentActionResultEntity>> addService({
    required int appointmentId,
    required int expectedFinancialVersion,
    required int serviceId,
    int? quantity,
    required String clientRequestId,
  });

  Future<Either<Failure, List<ServiceOptionEntity>>> getServiceOptions(
    int appointmentId, {
    String? search,
    int? page,
  });

  Future<Either<Failure, Map<String, dynamic>>> getVoucherPreview(
    int appointmentId,
    int voucherId,
  );
}
