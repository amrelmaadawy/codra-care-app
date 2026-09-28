import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_action_result_entity.dart';
import '../repositories/reception_payments_repository.dart';

class AddPaymentsUseCase {
  final ReceptionPaymentsRepository repository;

  const AddPaymentsUseCase(this.repository);

  Future<Either<Failure, PaymentActionResultEntity>> call({
    required int appointmentId,
    required int expectedFinancialVersion,
    required List<Map<String, dynamic>> payments,
    required String clientRequestId,
  }) {
    return repository.addPayments(
      appointmentId: appointmentId,
      expectedFinancialVersion: expectedFinancialVersion,
      payments: payments,
      clientRequestId: clientRequestId,
    );
  }
}
