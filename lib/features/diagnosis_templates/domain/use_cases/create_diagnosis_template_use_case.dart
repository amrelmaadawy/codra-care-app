import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/diagnosis_template_entity.dart';
import '../repositories/diagnosis_template_repository.dart';

class CreateDiagnosisTemplateUseCase {
  final DiagnosisTemplateRepository repository;

  const CreateDiagnosisTemplateUseCase(this.repository);

  Future<Either<Failure, DiagnosisTemplateEntity>> call({
    required String title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
  }) {
    return repository.createDiagnosisTemplate(
      title: title,
      chiefComplaint: chiefComplaint,
      diagnosis: diagnosis,
      notes: notes,
    );
  }
}
