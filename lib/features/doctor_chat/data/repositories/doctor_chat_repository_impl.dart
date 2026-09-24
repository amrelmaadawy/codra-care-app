import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_chat_init_entity.dart';
import '../../domain/entities/doctor_chat_message_entity.dart';
import '../../domain/entities/doctor_chat_poll_entity.dart';
import '../../domain/repositories/doctor_chat_repository.dart';
import '../data_sources/doctor_chat_remote_data_source.dart';

class DoctorChatRepositoryImpl implements DoctorChatRepository {
  final DoctorChatRemoteDataSource _remoteDataSource;

  const DoctorChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DoctorChatInitEntity>> initChat() async {
    try {
      final result = await _remoteDataSource.initChat();
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DoctorChatPollEntity>> pollMessages({
    int? afterId,
    bool isActive = true,
  }) async {
    try {
      final result = await _remoteDataSource.pollMessages(
        afterId: afterId,
        isActive: isActive,
      );
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DoctorChatMessageEntity>> sendMessage(String message) async {
    try {
      final result = await _remoteDataSource.sendMessage(message);
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead() async {
    try {
      await _remoteDataSource.markAsRead();
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await _remoteDataSource.getUnreadCount();
      return Right(count);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is DioException && exception.error != null) {
      return _mapExceptionToFailure(exception.error);
    }
    if (exception is UnauthorizedException) {
      return const UnauthorizedFailure();
    }
    if (exception is NetworkException) {
      return const NetworkFailure();
    }
    if (exception is NotFoundException) {
      return const NotFoundFailure();
    }
    if (exception is ServerException) {
      if (exception.fieldErrors != null && exception.fieldErrors!.isNotEmpty) {
        return ValidationFailure(
          message: exception.message,
          fieldErrors: exception.fieldErrors,
        );
      }
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    }
    return const UnexpectedFailure();
  }
}
