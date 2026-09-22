import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/diagnosis_template_entity.dart';
import '../entities/paginated_diagnosis_templates_entity.dart';

abstract class DiagnosisTemplateRepository {
  Future<Either<Failure, PaginatedDiagnosisTemplatesEntity>> getDiagnosisTemplates({
    int page = 1,
    String? search,
  });

  Future<Either<Failure, List<DiagnosisTemplateEntity>>> getDiagnosisTemplatesForExam({
    String? search,
    int limit = 50,
  });

  Future<Either<Failure, DiagnosisTemplateEntity>> getDiagnosisTemplateDetail(int id);

  Future<Either<Failure, DiagnosisTemplateEntity>> createDiagnosisTemplate({
    required String title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
  });

  Future<Either<Failure, DiagnosisTemplateEntity>> updateDiagnosisTemplate({
    required int id,
    required String title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
  });

  Future<Either<Failure, void>> deleteDiagnosisTemplate(int id);

  Future<Either<Failure, void>> useDiagnosisTemplate(int id);
}
