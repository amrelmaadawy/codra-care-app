import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/doctor_chat_repository.dart';

class GetDoctorChatUnreadCountUseCase {
  final DoctorChatRepository _repository;

  const GetDoctorChatUnreadCountUseCase(this._repository);

  Future<Either<Failure, int>> call() {
    return _repository.getUnreadCount();
  }
}
