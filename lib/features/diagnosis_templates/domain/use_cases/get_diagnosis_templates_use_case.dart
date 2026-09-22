import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/paginated_diagnosis_templates_entity.dart';
import '../repositories/diagnosis_template_repository.dart';

class GetDiagnosisTemplatesUseCase {
  final DiagnosisTemplateRepository repository;

  const GetDiagnosisTemplatesUseCase(this.repository);

  Future<Either<Failure, PaginatedDiagnosisTemplatesEntity>> call({
    int page = 1,
    String? search,
  }) {
    return repository.getDiagnosisTemplates(
      page: page,
      search: search,
    );
  }
}
