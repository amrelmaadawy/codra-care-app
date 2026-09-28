import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_action_result_entity.dart';
import '../repositories/reception_payments_repository.dart';

class AddRefundUseCase {
  final ReceptionPaymentsRepository repository;

  const AddRefundUseCase(this.repository);

  Future<Either<Failure, PaymentActionResultEntity>> call({
    required int appointmentId,
    required int expectedFinancialVersion,
    required String amount,
    String? reason,
    int? specificPaymentTransactionId,
    required String clientRequestId,
  }) {
    return repository.addRefund(
      appointmentId: appointmentId,
      expectedFinancialVersion: expectedFinancialVersion,
      amount: amount,
      reason: reason,
      specificPaymentTransactionId: specificPaymentTransactionId,
      clientRequestId: clientRequestId,
    );
  }
}
