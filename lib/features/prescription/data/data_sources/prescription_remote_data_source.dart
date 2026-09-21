import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/doctor_endpoints.dart';
import '../models/paginated_prescriptions_model.dart';
import '../models/prescription_context_model.dart';
import '../models/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<PaginatedPrescriptionsModel> getPrescriptions({
    int page = 1,
    String? search,
    String? dateFrom,
    String? dateTo,
    bool? isPrinted,
  });

  Future<PrescriptionContextModel> getCreateContext({
    int? visitId,
    int? patientId,
  });

  Future<PrescriptionModel> getPrescriptionDetail(int id);

  Future<PrescriptionModel> createPrescription({
    required int patientId,
    int? visitId,
    String? notes,
    required List<Map<String, dynamic>> items,
  });

  Future<PrescriptionModel> updatePrescription({
    required int id,
    int? patientId,
    int? visitId,
    String? notes,
    required List<Map<String, dynamic>> items,
  });

  Future<void> deletePrescription(int id);

  Future<PrescriptionModel> copyPrescription(int id);

  Future<void> markPrinted(int id);
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  final ApiClient _apiClient;

  const PrescriptionRemoteDataSourceImpl(this._apiClient);

  @override
  Future<PaginatedPrescriptionsModel> getPrescriptions({
    int page = 1,
    String? search,
    String? dateFrom,
    String? dateTo,
    bool? isPrinted,
  }) async {
    final queryParams = <String, dynamic>{'page': page};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    if (dateFrom != null && dateFrom.isNotEmpty) {
      queryParams['date_from'] = dateFrom;
    }
    if (dateTo != null && dateTo.isNotEmpty) {
      queryParams['date_to'] = dateTo;
    }
    if (isPrinted != null) {
      queryParams['is_printed'] = isPrinted ? '1' : '0';
    }

    final response = await _apiClient.dio.get(
      DoctorEndpoints.prescriptions,
      queryParameters: queryParams,
    );
    final data = _unwrapResponse(response);
    return PaginatedPrescriptionsModel.fromJson(data);
  }

  @override
  Future<PrescriptionContextModel> getCreateContext({
    int? visitId,
    int? patientId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (visitId != null) queryParams['visit_id'] = visitId;
    if (patientId != null) queryParams['patient_id'] = patientId;

    final response = await _apiClient.dio.get(
      DoctorEndpoints.prescriptionCreateContext,
      queryParameters: queryParams,
    );
    final data = _unwrapResponse(response);
    return PrescriptionContextModel.fromJson(data);
  }

  @override
  Future<PrescriptionModel> getPrescriptionDetail(int id) async {
    final response = await _apiClient.dio.get(
      DoctorEndpoints.prescriptionDetail(id),
    );
    final data = _unwrapResponse(response);
    return PrescriptionModel.fromJson(data);
  }

  @override
  Future<PrescriptionModel> createPrescription({
    required int patientId,
    int? visitId,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    final payload = <String, dynamic>{
      'patient_id': patientId,
      'items': items,
    };
    if (visitId != null) payload['visit_id'] = visitId;
    if (notes != null) payload['notes'] = notes;

    final response = await _apiClient.dio.post(
      DoctorEndpoints.prescriptions,
      data: payload,
    );
    final data = _unwrapResponse(response);
    return PrescriptionModel.fromJson(data);
  }

  @override
  Future<PrescriptionModel> updatePrescription({
    required int id,
    int? patientId,
    int? visitId,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    final payload = <String, dynamic>{'items': items};
    if (patientId != null) payload['patient_id'] = patientId;
    if (visitId != null) payload['visit_id'] = visitId;
    if (notes != null) payload['notes'] = notes;

    final response = await _apiClient.dio.put(
      DoctorEndpoints.prescriptionDetail(id),
      data: payload,
    );
    final data = _unwrapResponse(response);
    return PrescriptionModel.fromJson(data);
  }

  @override
  Future<void> deletePrescription(int id) async {
    final response = await _apiClient.dio.delete(
      DoctorEndpoints.prescriptionDetail(id),
    );
    _unwrapResponse(response);
  }

  @override
  Future<PrescriptionModel> copyPrescription(int id) async {
    final response = await _apiClient.dio.get(DoctorEndpoints.prescriptionCopy(id));
    final data = _unwrapResponse(response);
    return PrescriptionModel.fromJson(data);
  }

  @override
  Future<void> markPrinted(int id) async {
    final response = await _apiClient.dio.post(DoctorEndpoints.prescriptionMarkPrinted(id));
    _unwrapResponse(response);
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
