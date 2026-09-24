import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_chat_init_entity.dart';
import '../repositories/doctor_chat_repository.dart';

class InitDoctorChatUseCase {
  final DoctorChatRepository _repository;

  const InitDoctorChatUseCase(this._repository);

  Future<Either<Failure, DoctorChatInitEntity>> call() {
    return _repository.initChat();
  }
}
