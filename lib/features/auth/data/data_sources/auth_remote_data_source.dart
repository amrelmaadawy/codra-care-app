import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/auth_endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String tenantCode,
  });

  Future<void> logout();

  Future<Map<String, dynamic>> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  const AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String tenantCode,
  }) async {
    final response = await _apiClient.dio.post(
      AuthEndpoints.login,
      data: {
        'email': email,
        'password': password,
        'tenant_code': tenantCode,
      },
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => data as Map<String, dynamic>,
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw ServerException(
        message: apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'errors.unexpected',
        statusCode: response.statusCode ?? 500,
        fieldErrors: apiResponse.errors,
      );
    }

    return apiResponse.data!;
  }

  @override
  Future<void> logout() async {
    await _apiClient.dio.post(AuthEndpoints.logout);
  }

  @override
  Future<Map<String, dynamic>> getMe() async {
    final response = await _apiClient.dio.get(AuthEndpoints.me);
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => data as Map<String, dynamic>,
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw ServerException(
        message: apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'errors.unexpected',
        statusCode: response.statusCode ?? 500,
      );
    }

    return apiResponse.data!;
  }
}
