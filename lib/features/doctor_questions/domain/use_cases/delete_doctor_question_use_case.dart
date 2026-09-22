import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/doctor_question_repository.dart';

class DeleteDoctorQuestionUseCase {
  final DoctorQuestionRepository repository;

  const DeleteDoctorQuestionUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteQuestion(id);
  }
}
