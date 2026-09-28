import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/financial_snapshot_entity.dart';
import '../repositories/reception_payments_repository.dart';

class GetFinancialSnapshotUseCase {
  final ReceptionPaymentsRepository repository;

  const GetFinancialSnapshotUseCase(this.repository);

  Future<Either<Failure, FinancialSnapshotEntity>> call(int appointmentId) {
    return repository.getFinancialSnapshot(appointmentId);
  }
}
