import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/doctor_chat_repository.dart';

class MarkDoctorChatReadUseCase {
  final DoctorChatRepository _repository;

  const MarkDoctorChatReadUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.markAsRead();
  }
}
