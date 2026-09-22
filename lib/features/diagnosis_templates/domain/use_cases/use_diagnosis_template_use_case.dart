import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/diagnosis_template_repository.dart';

class UseDiagnosisTemplateUseCase {
  final DiagnosisTemplateRepository repository;

  const UseDiagnosisTemplateUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.useDiagnosisTemplate(id);
  }
}
