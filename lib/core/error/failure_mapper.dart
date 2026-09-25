import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';

abstract final class FailureMapper {
  static Failure mapExceptionToFailure(dynamic exception) {
    if (exception is DioException && exception.error != null) {
      return mapExceptionToFailure(exception.error);
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

  static String mapFailureToMessage(Failure failure) {
    if (failure is ValidationFailure) return failure.message;
    if (failure is ServerFailure) {
      if (failure.statusCode != null && failure.statusCode! >= 500) {
        return 'errors.server';
      }
      final msg = failure.message.toLowerCase();
      if (msg.contains('exception') ||
          msg.contains('attribute') ||
          msg.contains('sqlstate') ||
          msg.contains('model') ||
          msg.contains('undefined')) {
        return 'errors.server';
      }
      return failure.message;
    }
    if (failure is NetworkFailure) return 'errors.network';
    if (failure is UnauthorizedFailure) return 'errors.unauthorized';
    if (failure is NotFoundFailure) return 'errors.not_found';
    if (failure is CacheFailure) return 'errors.cache';
    return 'errors.unexpected';
  }
}
