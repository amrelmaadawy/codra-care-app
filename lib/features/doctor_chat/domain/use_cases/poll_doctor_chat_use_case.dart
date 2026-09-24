import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_chat_poll_entity.dart';
import '../repositories/doctor_chat_repository.dart';

class PollDoctorChatUseCase {
  final DoctorChatRepository _repository;

  const PollDoctorChatUseCase(this._repository);

  Future<Either<Failure, DoctorChatPollEntity>> call({
    int? afterId,
    bool isActive = true,
  }) {
    return _repository.pollMessages(
      afterId: afterId,
      isActive: isActive,
    );
  }
}
