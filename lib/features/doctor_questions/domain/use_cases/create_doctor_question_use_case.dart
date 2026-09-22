import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_question_entity.dart';
import '../repositories/doctor_question_repository.dart';

class CreateDoctorQuestionUseCase {
  final DoctorQuestionRepository repository;

  const CreateDoctorQuestionUseCase(this.repository);

  Future<Either<Failure, DoctorQuestionEntity>> call({
    required String text,
    required DoctorQuestionType type,
    List<String>? options,
    required bool isRequired,
    bool isActive = true,
  }) {
    return repository.createQuestion(
      text: text,
      type: type,
      options: options,
      isRequired: isRequired,
      isActive: isActive,
    );
  }
}
