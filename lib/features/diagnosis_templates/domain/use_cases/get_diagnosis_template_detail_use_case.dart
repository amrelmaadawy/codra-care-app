import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/diagnosis_template_entity.dart';
import '../repositories/diagnosis_template_repository.dart';

class GetDiagnosisTemplateDetailUseCase {
  final DiagnosisTemplateRepository repository;

  const GetDiagnosisTemplateDetailUseCase(this.repository);

  Future<Either<Failure, DiagnosisTemplateEntity>> call(int id) {
    return repository.getDiagnosisTemplateDetail(id);
  }
}
