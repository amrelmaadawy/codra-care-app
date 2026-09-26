import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_list_result_entity.dart';
import '../repositories/internal_chat_repository.dart';

class GetReceptionChatsUseCase {
  final InternalChatRepository repository;

  const GetReceptionChatsUseCase(this.repository);

  Future<Either<Failure, ChatListResultEntity>> call({
    String? search,
    String? status,
    int page = 1,
    int perPage = 20,
  }) {
    return repository.getReceptionChats(
      search: search,
      status: status,
      page: page,
      perPage: perPage,
    );
  }
}
