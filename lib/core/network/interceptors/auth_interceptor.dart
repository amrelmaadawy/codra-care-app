import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  const AuthInterceptor([this._storage = const FlutterSecureStorage()]);

  static const String tokenKey = 'auth_token';
  static const String tenantCodeKey = 'tenant_code';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    try {
      final token = await _storage.read(key: tokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      final tenantCode = await _storage.read(key: tenantCodeKey);
      if (tenantCode != null && tenantCode.isNotEmpty) {
        options.headers['X-Tenant-Code'] = tenantCode;
      }
    } catch (_) {
      // Storage read failure, continue without headers
    }

    super.onRequest(options, handler);
  }
}
