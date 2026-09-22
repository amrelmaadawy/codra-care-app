import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/diagnosis_template_entity.dart';
import '../repositories/diagnosis_template_repository.dart';

class UpdateDiagnosisTemplateUseCase {
  final DiagnosisTemplateRepository repository;

  const UpdateDiagnosisTemplateUseCase(this.repository);

  Future<Either<Failure, DiagnosisTemplateEntity>> call({
    required int id,
    required String title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
  }) {
    return repository.updateDiagnosisTemplate(
      id: id,
      title: title,
      chiefComplaint: chiefComplaint,
      diagnosis: diagnosis,
      notes: notes,
    );
  }
}
