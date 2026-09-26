import 'package:dartz/dartz.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/chat_conversation_page_entity.dart';
import '../../domain/entities/chat_list_result_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_poll_result_entity.dart';
import '../../domain/repositories/internal_chat_repository.dart';
import '../data_sources/internal_chat_remote_data_source.dart';

class InternalChatRepositoryImpl implements InternalChatRepository {
  final InternalChatRemoteDataSource _remoteDataSource;

  const InternalChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ChatListResultEntity>> getReceptionChats({
    String? search,
    String? status,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final result = await _remoteDataSource.getReceptionChats(
        search: search,
        status: status,
        page: page,
        perPage: perPage,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ChatConversationPageEntity>> getChatConversation({
    required int chatId,
    int? beforeId,
    int limit = 50,
  }) async {
    try {
      final result = await _remoteDataSource.getChatConversation(
        chatId: chatId,
        beforeId: beforeId,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ChatPollResultEntity>> pollChatMessages({
    required int chatId,
    required int afterId,
    int limit = 50,
  }) async {
    try {
      final result = await _remoteDataSource.pollChatMessages(
        chatId: chatId,
        afterId: afterId,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendReceptionMessage({
    required int chatId,
    required String message,
    required String clientMessageId,
  }) async {
    try {
      final result = await _remoteDataSource.sendReceptionMessage(
        chatId: chatId,
        message: message,
        clientMessageId: clientMessageId,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, int>> markChatAsRead({
    required int chatId,
    required int upToMessageId,
  }) async {
    try {
      final result = await _remoteDataSource.markChatAsRead(
        chatId: chatId,
        upToMessageId: upToMessageId,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, int>> getReceptionUnreadCount() async {
    try {
      final count = await _remoteDataSource.getReceptionUnreadCount();
      return Right(count);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }
}
