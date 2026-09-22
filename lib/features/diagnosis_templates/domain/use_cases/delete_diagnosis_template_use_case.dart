import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/diagnosis_template_repository.dart';

class DeleteDiagnosisTemplateUseCase {
  final DiagnosisTemplateRepository repository;

  const DeleteDiagnosisTemplateUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteDiagnosisTemplate(id);
  }
}
