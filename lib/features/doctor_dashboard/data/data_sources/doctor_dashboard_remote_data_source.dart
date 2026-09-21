import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/doctor_endpoints.dart';
import '../models/doctor_dashboard_model.dart';

abstract class DoctorDashboardRemoteDataSource {
  Future<DoctorDashboardModel> getDashboardStats();
}

class DoctorDashboardRemoteDataSourceImpl implements DoctorDashboardRemoteDataSource {
  final ApiClient _apiClient;

  const DoctorDashboardRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DoctorDashboardModel> getDashboardStats() async {
    final response = await _apiClient.dio.get(DoctorEndpoints.dashboard);

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

    return DoctorDashboardModel.fromJson(apiResponse.data!);
  }
}
