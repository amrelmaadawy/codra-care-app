import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_chat_message_entity.dart';
import '../repositories/doctor_chat_repository.dart';

class SendDoctorChatMessageUseCase {
  final DoctorChatRepository _repository;

  const SendDoctorChatMessageUseCase(this._repository);

  Future<Either<Failure, DoctorChatMessageEntity>> call(String message) {
    return _repository.sendMessage(message);
  }
}
