import 'dart:convert';
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
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 30),
        // Receive raw bytes and decode manually with UTF-8 to prevent
        // FormatException when \uXXXX sequences are split across TCP chunks
        // by the PHP built-in dev server.
        responseDecoder: _utf8Decoder,
      ),
    );

    dio.interceptors.addAll([
      const AuthInterceptor(),
      LocaleInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
      RetryInterceptor(dio),
    ]);
  }

  /// Decode response bytes as UTF-8 explicitly.
  /// This prevents Dart's JSON parser from seeing a partially-received
  /// escape sequence (e.g. a \uXXXX split across two TCP packets).
  static String? _utf8Decoder(
    List<int> responseBytes,
    RequestOptions options,
    ResponseBody responseBody,
  ) {
    return utf8.decode(responseBytes, allowMalformed: false);
  }
}
