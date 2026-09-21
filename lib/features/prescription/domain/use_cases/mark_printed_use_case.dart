import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/prescription_repository.dart';

class MarkPrintedUseCase {
  final PrescriptionRepository repository;

  const MarkPrintedUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.markPrinted(id);
  }
}
