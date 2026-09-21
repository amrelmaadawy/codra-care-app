import '../../../../core/error/failures.dart';

String mapPrescriptionFailure(Failure failure) {
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
  return 'errors.unexpected';
}
