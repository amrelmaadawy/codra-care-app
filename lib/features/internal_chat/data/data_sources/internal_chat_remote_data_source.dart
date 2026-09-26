import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/reception_endpoints.dart';
import '../models/chat_conversation_page_model.dart';
import '../models/chat_list_result_model.dart';
import '../models/chat_message_model.dart';
import '../models/chat_poll_result_model.dart';

abstract class InternalChatRemoteDataSource {
  Future<ChatListResultModel> getReceptionChats({
    String? search,
    String? status,
    int page = 1,
    int perPage = 20,
  });

  Future<ChatConversationPageModel> getChatConversation({
    required int chatId,
    int? beforeId,
    int limit = 50,
  });

  Future<ChatPollResultModel> pollChatMessages({
    required int chatId,
    required int afterId,
    int limit = 50,
  });

  Future<ChatMessageModel> sendReceptionMessage({
    required int chatId,
    required String message,
    required String clientMessageId,
  });

  Future<int> markChatAsRead({
    required int chatId,
    required int upToMessageId,
  });

  Future<int> getReceptionUnreadCount();
}

class InternalChatRemoteDataSourceImpl implements InternalChatRemoteDataSource {
  final ApiClient _apiClient;

  const InternalChatRemoteDataSourceImpl(this._apiClient);

  Map<String, dynamic> _extractData(Response response) {
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
  Future<ChatListResultModel> getReceptionChats({
    String? search,
    String? status,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{'page': page, 'per_page': perPage};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final response = await _apiClient.dio.get(
      ReceptionEndpoints.internalChats,
      queryParameters: queryParams,
    );
    return ChatListResultModel.fromJson(_extractData(response));
  }

  @override
  Future<ChatConversationPageModel> getChatConversation({
    required int chatId,
    int? beforeId,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (beforeId != null) queryParams['before_id'] = beforeId;

    final response = await _apiClient.dio.get(
      ReceptionEndpoints.internalChatDetail(chatId),
      queryParameters: queryParams,
    );
    return ChatConversationPageModel.fromJson(_extractData(response));
  }

  @override
  Future<ChatPollResultModel> pollChatMessages({
    required int chatId,
    required int afterId,
    int limit = 50,
  }) async {
    final response = await _apiClient.dio.get(
      ReceptionEndpoints.internalChatPoll(chatId),
      queryParameters: {'after_id': afterId, 'limit': limit},
    );
    return ChatPollResultModel.fromJson(_extractData(response));
  }

  @override
  Future<ChatMessageModel> sendReceptionMessage({
    required int chatId,
    required String message,
    required String clientMessageId,
  }) async {
    final response = await _apiClient.dio.post(
      ReceptionEndpoints.internalChatSend(chatId),
      data: {'message': message, 'client_message_id': clientMessageId},
    );
    final data = _extractData(response);
    final messageMap = data['message'] is Map<String, dynamic>
        ? data['message'] as Map<String, dynamic>
        : data;
    return ChatMessageModel.fromJson(messageMap);
  }

  @override
  Future<int> markChatAsRead({
    required int chatId,
    required int upToMessageId,
  }) async {
    final response = await _apiClient.dio.post(
      ReceptionEndpoints.internalChatRead(chatId),
      data: {'up_to_message_id': upToMessageId},
    );
    final data = _extractData(response);
    final count = data['unread_by_reception'] ?? data['unread_count'] ?? 0;
    return count is int ? count : int.tryParse(count.toString()) ?? 0;
  }

  @override
  Future<int> getReceptionUnreadCount() async {
    final response = await _apiClient.dio.get(
      ReceptionEndpoints.internalChatUnreadCount,
    );
    final data = _extractData(response);
    final count = data['total_unread'] ?? 0;
    return count is int ? count : int.tryParse(count.toString()) ?? 0;
  }
}
