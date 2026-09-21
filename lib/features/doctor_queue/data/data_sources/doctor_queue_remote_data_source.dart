import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/doctor_endpoints.dart';
import '../models/doctor_queue_model.dart';

abstract class DoctorQueueRemoteDataSource {
  Future<DoctorQueueModel> getQueue();
  Future<void> callPatient(int id);
  Future<void> completePatient(int id);
  Future<void> cancelPatient(int id);
}

class DoctorQueueRemoteDataSourceImpl implements DoctorQueueRemoteDataSource {
  final ApiClient _apiClient;

  const DoctorQueueRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DoctorQueueModel> getQueue() async {
    final response = await _apiClient.dio.get(DoctorEndpoints.queue);

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

    return DoctorQueueModel.fromJson(apiResponse.data!);
  }

  @override
  Future<void> callPatient(int id) async {
    await _postAction(DoctorEndpoints.callQueue(id));
  }

  @override
  Future<void> completePatient(int id) async {
    await _postAction(DoctorEndpoints.completeQueue(id));
  }

  @override
  Future<void> cancelPatient(int id) async {
    await _postAction(DoctorEndpoints.cancelQueue(id));
  }

  Future<void> _postAction(String endpoint) async {
    final response = await _apiClient.dio.post(endpoint);

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
}
