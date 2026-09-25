import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/reception_endpoints.dart';
import '../models/reception_dashboard_model.dart';

abstract class ReceptionDashboardRemoteDataSource {
  Future<ReceptionDashboardModel> getDashboard({int? doctorId});
}

class ReceptionDashboardRemoteDataSourceImpl
    implements ReceptionDashboardRemoteDataSource {
  final ApiClient _apiClient;

  const ReceptionDashboardRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ReceptionDashboardModel> getDashboard({int? doctorId}) async {
    final response = await _apiClient.dio.get(
      ReceptionEndpoints.dashboard,
      queryParameters: doctorId != null ? {'doctor_id': doctorId} : null,
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

    return ReceptionDashboardModel.fromJson(apiResponse.data!);
  }
}
