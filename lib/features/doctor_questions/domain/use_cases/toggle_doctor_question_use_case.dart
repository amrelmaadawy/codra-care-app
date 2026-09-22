import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_question_entity.dart';
import '../repositories/doctor_question_repository.dart';

class ToggleDoctorQuestionUseCase {
  final DoctorQuestionRepository repository;

  const ToggleDoctorQuestionUseCase(this.repository);

  Future<Either<Failure, DoctorQuestionEntity>> call(int id) {
    return repository.toggleQuestion(id);
  }
}
