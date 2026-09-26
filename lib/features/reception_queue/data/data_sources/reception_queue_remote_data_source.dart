import 'package:uuid/uuid.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints/reception_endpoints.dart';
import '../../domain/entities/queue_filter.dart';
import '../models/reception_queue_item_model.dart';
import '../models/reception_queue_model.dart';

abstract class ReceptionQueueRemoteDataSource {
  Future<ReceptionQueueModel> getQueue(QueueFilter filter);

  Future<ReceptionQueueItemModel> togglePresence({
    required int id,
    required bool isPresent,
    String? clientRequestId,
  });

  Future<ReceptionQueueItemModel> saveVitals({
    required int id,
    required Map<String, dynamic> vitals,
    String? clientRequestId,
  });

  Future<ReceptionQueueItemModel> callDoctor({
    required int id,
    String? clientRequestId,
  });

  Future<ReceptionQueueItemModel> complete({
    required int id,
    String? clientRequestId,
  });

  Future<ReceptionQueueItemModel> cancel({
    required int id,
    required String reason,
    String? clientRequestId,
  });
}

class ReceptionQueueRemoteDataSourceImpl implements ReceptionQueueRemoteDataSource {
  final ApiClient _apiClient;
  static const _uuid = Uuid();

  const ReceptionQueueRemoteDataSourceImpl(this._apiClient);

  String _resolveRequestId(String? clientRequestId) =>
      clientRequestId ?? _uuid.v4();

  @override
  Future<ReceptionQueueModel> getQueue(QueueFilter filter) async {
    final response = await _apiClient.dio.get(
      ReceptionEndpoints.queue,
      queryParameters: filter.toQueryParams(),
    );
    final data = response.data as Map<String, dynamic>;
    return ReceptionQueueModel.fromJson(data);
  }

  @override
  Future<ReceptionQueueItemModel> togglePresence({
    required int id,
    required bool isPresent,
    String? clientRequestId,
  }) async {
    final response = await _apiClient.dio.post(
      ReceptionEndpoints.queuePresence(id),
      data: {
        'is_present': isPresent,
        'client_request_id': _resolveRequestId(clientRequestId),
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ReceptionQueueItemModel.fromJson(data);
  }

  @override
  Future<ReceptionQueueItemModel> saveVitals({
    required int id,
    required Map<String, dynamic> vitals,
    String? clientRequestId,
  }) async {
    final response = await _apiClient.dio.post(
      ReceptionEndpoints.queueVitals(id),
      data: {
        'vital_signs': vitals,
        'client_request_id': _resolveRequestId(clientRequestId),
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ReceptionQueueItemModel.fromJson(data);
  }

  @override
  Future<ReceptionQueueItemModel> callDoctor({
    required int id,
    String? clientRequestId,
  }) async {
    final response = await _apiClient.dio.post(
      ReceptionEndpoints.queueCallDoctor(id),
      data: {
        'client_request_id': _resolveRequestId(clientRequestId),
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ReceptionQueueItemModel.fromJson(data);
  }

  @override
  Future<ReceptionQueueItemModel> complete({
    required int id,
    String? clientRequestId,
  }) async {
    final response = await _apiClient.dio.post(
      ReceptionEndpoints.queueComplete(id),
      data: {
        'client_request_id': _resolveRequestId(clientRequestId),
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ReceptionQueueItemModel.fromJson(data);
  }

  @override
  Future<ReceptionQueueItemModel> cancel({
    required int id,
    required String reason,
    String? clientRequestId,
  }) async {
    final response = await _apiClient.dio.post(
      ReceptionEndpoints.queueCancel(id),
      data: {
        'reason': reason,
        'client_request_id': _resolveRequestId(clientRequestId),
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ReceptionQueueItemModel.fromJson(data);
  }
}
