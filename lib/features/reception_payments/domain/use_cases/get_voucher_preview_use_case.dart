import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/reception_payments_repository.dart';

class GetVoucherPreviewUseCase {
  final ReceptionPaymentsRepository repository;

  const GetVoucherPreviewUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
    int appointmentId,
    int voucherId,
  ) {
    return repository.getVoucherPreview(appointmentId, voucherId);
  }
}
