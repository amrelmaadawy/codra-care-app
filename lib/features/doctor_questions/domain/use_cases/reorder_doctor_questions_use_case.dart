import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/doctor_question_repository.dart';

class ReorderDoctorQuestionsUseCase {
  final DoctorQuestionRepository repository;

  const ReorderDoctorQuestionsUseCase(this.repository);

  Future<Either<Failure, void>> call(List<int> orderedIds) {
    return repository.reorderQuestions(orderedIds);
  }
}
