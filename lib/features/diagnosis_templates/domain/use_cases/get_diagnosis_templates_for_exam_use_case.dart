import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/diagnosis_template_entity.dart';
import '../repositories/diagnosis_template_repository.dart';

class GetDiagnosisTemplatesForExamUseCase {
  final DiagnosisTemplateRepository repository;

  const GetDiagnosisTemplatesForExamUseCase(this.repository);

  Future<Either<Failure, List<DiagnosisTemplateEntity>>> call({
    String? search,
    int limit = 50,
  }) {
    return repository.getDiagnosisTemplatesForExam(
      search: search,
      limit: limit,
    );
  }
}
