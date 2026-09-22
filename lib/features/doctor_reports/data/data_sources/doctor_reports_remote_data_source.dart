import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/doctor_endpoints.dart';
import '../models/doctor_reports_response_model.dart';

abstract class DoctorReportsRemoteDataSource {
  Future<DoctorReportsResponseModel> getReports({
    int? month,
    int? year,
    int page = 1,
    int perPage = 15,
    String? search,
  });
}

class DoctorReportsRemoteDataSourceImpl
    implements DoctorReportsRemoteDataSource {
  final ApiClient _apiClient;

  const DoctorReportsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DoctorReportsResponseModel> getReports({
    int? month,
    int? year,
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (month != null && month > 0) {
      queryParams['month'] = month;
    }
    if (year != null && year > 0) {
      queryParams['year'] = year;
    }
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    final response = await _apiClient.dio.get(
      DoctorEndpoints.reports,
      queryParameters: queryParams,
    );
    final data = _unwrapResponse(response);
    return DoctorReportsResponseModel.fromJson(data);
  }

  Map<String, dynamic> _unwrapResponse(Response response) {
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

    if (apiResponse.data is Map) {
      return Map<String, dynamic>.from(apiResponse.data as Map);
    }
    return <String, dynamic>{};
  }
}
