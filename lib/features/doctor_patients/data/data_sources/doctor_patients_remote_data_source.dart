import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/doctor_endpoints.dart';
import '../models/patient_detail_model.dart';
import '../models/patient_list_result_model.dart';

abstract class DoctorPatientsRemoteDataSource {
  Future<PatientListResultModel> getPatients({
    String? search,
    int page = 1,
  });

  Future<PatientDetailModel> getPatientDetail(int id);
}

class DoctorPatientsRemoteDataSourceImpl
    implements DoctorPatientsRemoteDataSource {
  final ApiClient _apiClient;

  const DoctorPatientsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<PatientListResultModel> getPatients({
    String? search,
    int page = 1,
  }) async {
    final queryParams = <String, dynamic>{'page': page};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    final response = await _apiClient.dio.get(
      DoctorEndpoints.patients,
      queryParameters: queryParams,
    );
    final data = _unwrapResponse(response);
    return PatientListResultModel.fromJson(data);
  }

  @override
  Future<PatientDetailModel> getPatientDetail(int id) async {
    final response = await _apiClient.dio.get(
      DoctorEndpoints.patientDetail(id),
    );
    final data = _unwrapResponse(response);
    return PatientDetailModel.fromJson(data);
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
