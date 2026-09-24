import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/doctor_endpoints.dart';
import '../models/doctor_chat_init_model.dart';
import '../models/doctor_chat_message_model.dart';
import '../models/doctor_chat_poll_model.dart';

abstract class DoctorChatRemoteDataSource {
  Future<DoctorChatInitModel> initChat();

  Future<DoctorChatPollModel> pollMessages({
    int? afterId,
    bool isActive = true,
  });

  Future<DoctorChatMessageModel> sendMessage(String message);

  Future<void> markAsRead();

  Future<int> getUnreadCount();
}

class DoctorChatRemoteDataSourceImpl implements DoctorChatRemoteDataSource {
  final ApiClient _apiClient;

  const DoctorChatRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DoctorChatInitModel> initChat() async {
    final response = await _apiClient.dio.get(DoctorEndpoints.chatInit);
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

    return DoctorChatInitModel.fromJson(apiResponse.data!);
  }

  @override
  Future<DoctorChatPollModel> pollMessages({
    int? afterId,
    bool isActive = true,
  }) async {
    final queryParams = <String, dynamic>{
      'is_active': isActive ? 1 : 0,
    };
    if (afterId != null) {
      queryParams['after_id'] = afterId;
    }

    final response = await _apiClient.dio.get(
      DoctorEndpoints.chatPoll,
      queryParameters: queryParams,
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

    return DoctorChatPollModel.fromJson(apiResponse.data!);
  }

  @override
  Future<DoctorChatMessageModel> sendMessage(String message) async {
    final response = await _apiClient.dio.post(
      DoctorEndpoints.chatSend,
      data: {'message': message},
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

    return DoctorChatMessageModel.fromJson(apiResponse.data!);
  }

  @override
  Future<void> markAsRead() async {
    final response = await _apiClient.dio.post(DoctorEndpoints.chatRead);
    final apiResponse = ApiResponse<dynamic>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => data,
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
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _apiClient.dio.get(DoctorEndpoints.chatUnreadCount);
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

    return apiResponse.data!['unread_count'] as int? ?? 0;
  }
}
