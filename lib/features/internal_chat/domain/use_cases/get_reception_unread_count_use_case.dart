import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/internal_chat_repository.dart';

class GetReceptionUnreadCountUseCase {
  final InternalChatRepository repository;

  const GetReceptionUnreadCountUseCase(this.repository);

  Future<Either<Failure, int>> call() {
    return repository.getReceptionUnreadCount();
  }
}
