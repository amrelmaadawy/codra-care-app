import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_action_result_entity.dart';
import '../repositories/reception_payments_repository.dart';

class AddAppointmentServiceUseCase {
  final ReceptionPaymentsRepository repository;

  const AddAppointmentServiceUseCase(this.repository);

  Future<Either<Failure, PaymentActionResultEntity>> call({
    required int appointmentId,
    required int expectedFinancialVersion,
    required int serviceId,
    int? quantity,
    required String clientRequestId,
  }) {
    return repository.addService(
      appointmentId: appointmentId,
      expectedFinancialVersion: expectedFinancialVersion,
      serviceId: serviceId,
      quantity: quantity,
      clientRequestId: clientRequestId,
    );
  }
}
