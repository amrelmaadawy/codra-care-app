import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? fieldErrors;

  const Failure({
    required this.message,
    this.statusCode,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, statusCode, fieldErrors];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'errors.network'});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'errors.unauthorized'});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'errors.not_found'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.fieldErrors,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'errors.cache'});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'errors.unexpected'});
}
