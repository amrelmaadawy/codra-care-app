import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}');
      debugPrint('Headers: ${options.headers.keys.toList()}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- ${response.statusCode} ${response.requestOptions.path}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final status = err.response?.statusCode != null
          ? '${err.response!.statusCode}'
          : err.type.name;
      final data = err.response?.data;
      final msg = data != null ? '$data' : (err.error ?? err.message ?? '');
      debugPrint('<-- ERROR [$status] ${err.requestOptions.path}: $msg');
    }
    super.onError(err, handler);
  }
}
