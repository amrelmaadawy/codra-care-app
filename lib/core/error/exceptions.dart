import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? fieldErrors;

  const ServerException({
    required this.message,
    required this.statusCode,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, statusCode, fieldErrors];

  @override
  String toString() =>
      'ServerException(statusCode: $statusCode, message: $message, fieldErrors: $fieldErrors)';
}

class NetworkException implements Exception {
  const NetworkException();

  @override
  String toString() => 'NetworkException: No internet connection or timeout';
}

class UnauthorizedException implements Exception {
  const UnauthorizedException();

  @override
  String toString() => 'UnauthorizedException: Session expired or invalid credentials';
}

class NotFoundException implements Exception {
  const NotFoundException();

  @override
  String toString() => 'NotFoundException: Requested resource was not found';
}

class CacheException implements Exception {
  const CacheException();

  @override
  String toString() => 'CacheException: Failed to read or write local cache';
}
