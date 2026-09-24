import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_chat_init_entity.dart';
import '../entities/doctor_chat_message_entity.dart';
import '../entities/doctor_chat_poll_entity.dart';

abstract class DoctorChatRepository {
  Future<Either<Failure, DoctorChatInitEntity>> initChat();

  Future<Either<Failure, DoctorChatPollEntity>> pollMessages({
    int? afterId,
    bool isActive = true,
  });

  Future<Either<Failure, DoctorChatMessageEntity>> sendMessage(String message);

  Future<Either<Failure, void>> markAsRead();

  Future<Either<Failure, int>> getUnreadCount();
}
