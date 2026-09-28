import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_action_result_entity.dart';
import '../repositories/reception_payments_repository.dart';

class AddDiscountUseCase {
  final ReceptionPaymentsRepository repository;

  const AddDiscountUseCase(this.repository);

  Future<Either<Failure, PaymentActionResultEntity>> call({
    required int appointmentId,
    required int expectedFinancialVersion,
    required String amount,
    required String reason,
    required String clientRequestId,
  }) {
    return repository.addDiscount(
      appointmentId: appointmentId,
      expectedFinancialVersion: expectedFinancialVersion,
      amount: amount,
      reason: reason,
      clientRequestId: clientRequestId,
    );
  }
}
