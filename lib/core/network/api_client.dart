import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/locale_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

class ApiClient {
  ApiClient._();
  static ApiClient? _instance;
  static ApiClient get instance => _instance ??= ApiClient._();

  late final Dio dio;

  void initialize({String? customBaseUrl}) {
    final baseUrl = customBaseUrl ??
        dotenv.env['API_BASE_URL'] ??
        'http://10.0.2.2:8000/api/mobile';

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.addAll([
      LoggingInterceptor(),
      const AuthInterceptor(),
      LocaleInterceptor(),
      ErrorInterceptor(),
      RetryInterceptor(dio),
    ]);
  }
}
