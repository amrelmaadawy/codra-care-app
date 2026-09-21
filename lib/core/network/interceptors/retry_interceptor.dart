import 'dart:async';
import 'package:dio/dio.dart';
import '../../error/exceptions.dart';

class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;

  RetryInterceptor(this._dio, {this.maxRetries = 3});

  static const String _retryCountKey = 'extra_retry_count';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final int currentRetries = (extra[_retryCountKey] as int?) ?? 0;

    final isNetworkError = err.error is NetworkException;

    if (isNetworkError && currentRetries < maxRetries) {
      final nextRetry = currentRetries + 1;
      extra[_retryCountKey] = nextRetry;

      final delaySeconds = 1 << (nextRetry - 1); // 1s -> 2s -> 4s
      await Future.delayed(Duration(seconds: delaySeconds));

      try {
        final response = await _dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (retryErr) {
        return handler.next(retryErr);
      } catch (e) {
        return handler.next(err);
      }
    }

    super.onError(err, handler);
  }
}
