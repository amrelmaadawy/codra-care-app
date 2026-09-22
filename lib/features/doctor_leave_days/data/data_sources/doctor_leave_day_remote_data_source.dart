import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/doctor_endpoints.dart';
import '../models/doctor_leave_days_summary_model.dart';

abstract class DoctorLeaveDayRemoteDataSource {
  Future<DoctorLeaveDaysSummaryModel> getSummaryData();

  Future<int> checkAppointmentsCount({
    String? date,
    String? startDate,
    String? endDate,
  });

  Future<DoctorLeaveDaysSummaryModel> addLeave({
    String? leaveDate,
    String? startDate,
    String? endDate,
    String? reason,
  });

  Future<DoctorLeaveDaysSummaryModel> deleteLeave(int id);

  Future<DoctorLeaveDaysSummaryModel> deleteLeaveByDate(String date);
}

class DoctorLeaveDayRemoteDataSourceImpl
    implements DoctorLeaveDayRemoteDataSource {
  final ApiClient _apiClient;

  const DoctorLeaveDayRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DoctorLeaveDaysSummaryModel> getSummaryData() async {
    final response = await _apiClient.dio.get(DoctorEndpoints.leaveDays);
    final data = _unwrapResponse(response);
    return DoctorLeaveDaysSummaryModel.fromJson(data);
  }

  @override
  Future<int> checkAppointmentsCount({
    String? date,
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (date != null && date.isNotEmpty) {
      queryParams['date'] = date;
    }
    if (startDate != null && startDate.isNotEmpty) {
      queryParams['start_date'] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      queryParams['end_date'] = endDate;
    }

    final response = await _apiClient.dio.get(
      DoctorEndpoints.leaveDaysAppointmentsCount,
      queryParameters: queryParams,
    );
    final data = _unwrapResponse(response);
    return (data['appointments_count'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<DoctorLeaveDaysSummaryModel> addLeave({
    String? leaveDate,
    String? startDate,
    String? endDate,
    String? reason,
  }) async {
    final body = <String, dynamic>{};
    if (leaveDate != null && leaveDate.isNotEmpty) {
      body['leave_date'] = leaveDate;
    }
    if (startDate != null && startDate.isNotEmpty) {
      body['start_date'] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      body['end_date'] = endDate;
    }
    if (reason != null && reason.trim().isNotEmpty) {
      body['reason'] = reason.trim();
    }

    final response = await _apiClient.dio.post(
      DoctorEndpoints.leaveDays,
      data: body,
    );
    _unwrapResponse(response);
    return getSummaryData();
  }

  @override
  Future<DoctorLeaveDaysSummaryModel> deleteLeave(int id) async {
    final response = await _apiClient.dio.delete(
      DoctorEndpoints.leaveDayDetail(id),
    );
    _unwrapResponse(response);
    return getSummaryData();
  }

  @override
  Future<DoctorLeaveDaysSummaryModel> deleteLeaveByDate(String date) async {
    final response = await _apiClient.dio.delete(
      DoctorEndpoints.leaveDaysByDate,
      queryParameters: {'date': date},
    );
    _unwrapResponse(response);
    return getSummaryData();
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
