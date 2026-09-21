import 'dart:io';
import 'package:dio/dio.dart';
import '../../error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Exception mappedException;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        mappedException = const NetworkException();
        break;
      case DioExceptionType.badResponse:
        final response = err.response;
        final statusCode = response?.statusCode ?? 500;
        final data = response?.data;

        if (statusCode == HttpStatus.unauthorized) {
          mappedException = const UnauthorizedException();
        } else if (statusCode == HttpStatus.notFound) {
          mappedException = const NotFoundException();
        } else if (data is Map<String, dynamic>) {
          final message = data['message'] as String? ?? 'Server Error';
          final errors = data['errors'] as Map<String, dynamic>?;
          mappedException = ServerException(
            message: message,
            statusCode: statusCode,
            fieldErrors: errors,
          );
        } else {
          mappedException = ServerException(
            message: 'Server Error with status code $statusCode',
            statusCode: statusCode,
          );
        }
        break;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      default:
        if (err.error is SocketException) {
          mappedException = const NetworkException();
        } else {
          mappedException = ServerException(
            message: err.message ?? 'Unexpected network error',
            statusCode: err.response?.statusCode ?? 500,
          );
        }
        break;
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mappedException,
        message: err.message,
      ),
    );
  }
}
