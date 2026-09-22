import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_question_entity.dart';
import '../repositories/doctor_question_repository.dart';

class UpdateDoctorQuestionUseCase {
  final DoctorQuestionRepository repository;

  const UpdateDoctorQuestionUseCase(this.repository);

  Future<Either<Failure, DoctorQuestionEntity>> call({
    required int id,
    required String text,
    required DoctorQuestionType type,
    List<String>? options,
    required bool isRequired,
  }) {
    return repository.updateQuestion(
      id: id,
      text: text,
      type: type,
      options: options,
      isRequired: isRequired,
    );
  }
}
