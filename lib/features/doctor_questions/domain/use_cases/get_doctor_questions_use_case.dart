import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_question_entity.dart';
import '../repositories/doctor_question_repository.dart';

class GetDoctorQuestionsUseCase {
  final DoctorQuestionRepository repository;

  const GetDoctorQuestionsUseCase(this.repository);

  Future<Either<Failure, List<DoctorQuestionEntity>>> call() {
    return repository.getQuestions();
  }
}
