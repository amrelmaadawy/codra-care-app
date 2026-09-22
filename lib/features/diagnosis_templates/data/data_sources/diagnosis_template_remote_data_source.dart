import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/doctor_endpoints.dart';
import '../models/diagnosis_template_model.dart';
import '../models/paginated_diagnosis_templates_model.dart';

abstract class DiagnosisTemplateRemoteDataSource {
  Future<PaginatedDiagnosisTemplatesModel> getDiagnosisTemplates({
    int page = 1,
    String? search,
  });

  Future<List<DiagnosisTemplateModel>> getDiagnosisTemplatesForExam({
    String? search,
    int limit = 50,
  });

  Future<DiagnosisTemplateModel> getDiagnosisTemplateDetail(int id);

  Future<DiagnosisTemplateModel> createDiagnosisTemplate({
    required String title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
  });

  Future<DiagnosisTemplateModel> updateDiagnosisTemplate({
    required int id,
    required String title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
  });

  Future<void> deleteDiagnosisTemplate(int id);

  Future<void> useDiagnosisTemplate(int id);
}

class DiagnosisTemplateRemoteDataSourceImpl
    implements DiagnosisTemplateRemoteDataSource {
  final ApiClient _apiClient;

  const DiagnosisTemplateRemoteDataSourceImpl(this._apiClient);

  @override
  Future<PaginatedDiagnosisTemplatesModel> getDiagnosisTemplates({
    int page = 1,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{'page': page};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    final response = await _apiClient.dio.get(
      DoctorEndpoints.diagnosisTemplates,
      queryParameters: queryParams,
    );
    final data = _unwrapResponse(response);
    return PaginatedDiagnosisTemplatesModel.fromJson(data);
  }

  @override
  Future<List<DiagnosisTemplateModel>> getDiagnosisTemplatesForExam({
    String? search,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['q'] = search.trim();
    }

    final response = await _apiClient.dio.get(
      DoctorEndpoints.diagnosisTemplatesForExam,
      queryParameters: queryParams,
    );
    final list = _unwrapListResponse(response);
    return list.map(DiagnosisTemplateModel.fromJson).toList();
  }

  @override
  Future<DiagnosisTemplateModel> getDiagnosisTemplateDetail(int id) async {
    final response = await _apiClient.dio.get(
      DoctorEndpoints.diagnosisTemplateDetail(id),
    );
    final data = _unwrapResponse(response);
    return DiagnosisTemplateModel.fromJson(data);
  }

  @override
  Future<DiagnosisTemplateModel> createDiagnosisTemplate({
    required String title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
  }) async {
    final body = <String, dynamic>{'title': title};
    if (chiefComplaint != null && chiefComplaint.trim().isNotEmpty) {
      body['chief_complaint'] = chiefComplaint.trim();
    }
    if (diagnosis != null && diagnosis.trim().isNotEmpty) {
      body['diagnosis'] = diagnosis.trim();
    }
    if (notes != null && notes.trim().isNotEmpty) {
      body['notes'] = notes.trim();
    }

    final response = await _apiClient.dio.post(
      DoctorEndpoints.diagnosisTemplates,
      data: body,
    );
    final data = _unwrapResponse(response);
    return DiagnosisTemplateModel.fromJson(data);
  }

  @override
  Future<DiagnosisTemplateModel> updateDiagnosisTemplate({
    required int id,
    required String title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'chief_complaint': chiefComplaint?.trim() ?? '',
      'diagnosis': diagnosis?.trim() ?? '',
      'notes': notes?.trim() ?? '',
    };

    final response = await _apiClient.dio.put(
      DoctorEndpoints.diagnosisTemplateUpdate(id),
      data: body,
    );
    final data = _unwrapResponse(response);
    return DiagnosisTemplateModel.fromJson(data);
  }

  @override
  Future<void> deleteDiagnosisTemplate(int id) async {
    final response = await _apiClient.dio.delete(
      DoctorEndpoints.diagnosisTemplateDelete(id),
    );
    _unwrapResponse(response);
  }

  @override
  Future<void> useDiagnosisTemplate(int id) async {
    final response = await _apiClient.dio.post(
      DoctorEndpoints.diagnosisTemplateUse(id),
    );
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

  List<Map<String, dynamic>> _unwrapListResponse(Response response) {
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

    if (apiResponse.data is List) {
      return (apiResponse.data as List)
          .whereType<Map<String, dynamic>>()
          .toList();
    }
    return <Map<String, dynamic>>[];
  }
}
