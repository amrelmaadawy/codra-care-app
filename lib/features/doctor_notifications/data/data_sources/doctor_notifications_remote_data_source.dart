import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/doctor_endpoints.dart';
import '../../domain/entities/doctor_notification_entity.dart';
import '../models/doctor_notification_model.dart';

abstract class DoctorNotificationsRemoteDataSource {
  Future<DoctorNotificationsModel> getNotifications();

  Future<bool> markAsRead({
    required NotificationType type,
    required dynamic id,
  });

  Future<bool> markAll();
}

class DoctorNotificationsRemoteDataSourceImpl
    implements DoctorNotificationsRemoteDataSource {
  final ApiClient _apiClient;

  const DoctorNotificationsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DoctorNotificationsModel> getNotifications() async {
    final response = await _apiClient.dio.get(DoctorEndpoints.notifications);
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

    return DoctorNotificationsModel.fromJson(apiResponse.data!);
  }

  @override
  Future<bool> markAsRead({
    required NotificationType type,
    required dynamic id,
  }) async {
    final response = await _apiClient.dio.post(
      DoctorEndpoints.notificationsMarkRead,
      data: {'type': type.toApiString(), 'id': id},
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => data as Map<String, dynamic>,
    );

    if (!apiResponse.success) {
      throw ServerException(
        message: apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'errors.unexpected',
        statusCode: response.statusCode ?? 500,
        fieldErrors: apiResponse.errors,
      );
    }

    return apiResponse.data?['dismissed'] as bool? ?? false;
  }

  @override
  Future<bool> markAll() async {
    final response = await _apiClient.dio.post(DoctorEndpoints.notificationsMarkAll);
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => data as Map<String, dynamic>,
    );

    if (!apiResponse.success) {
      throw ServerException(
        message: apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'errors.unexpected',
        statusCode: response.statusCode ?? 500,
        fieldErrors: apiResponse.errors,
      );
    }

    return apiResponse.data?['dismissed_all'] as bool? ?? false;
  }
}
