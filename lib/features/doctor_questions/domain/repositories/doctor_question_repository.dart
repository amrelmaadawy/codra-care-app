import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_question_entity.dart';

abstract class DoctorQuestionRepository {
  Future<Either<Failure, List<DoctorQuestionEntity>>> getQuestions();

  Future<Either<Failure, DoctorQuestionEntity>> createQuestion({
    required String text,
    required DoctorQuestionType type,
    List<String>? options,
    required bool isRequired,
    bool isActive = true,
  });

  Future<Either<Failure, DoctorQuestionEntity>> updateQuestion({
    required int id,
    required String text,
    required DoctorQuestionType type,
    List<String>? options,
    required bool isRequired,
  });

  Future<Either<Failure, void>> deleteQuestion(int id);

  Future<Either<Failure, DoctorQuestionEntity>> toggleQuestion(int id);

  Future<Either<Failure, void>> reorderQuestions(List<int> orderedIds);
}
