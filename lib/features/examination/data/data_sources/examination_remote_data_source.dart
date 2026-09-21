import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/doctor_endpoints.dart';
import '../models/examination_model.dart';
import '../models/visit_image_model.dart';

abstract class ExaminationRemoteDataSource {
  Future<int> startExamination(int waitingListId);
  Future<ExaminationModel> getExamination(int visitId);
  Future<Map<String, dynamic>> saveSection({
    required int visitId,
    required String section,
    required Map<String, dynamic> data,
  });
  Future<List<VisitImageModel>> uploadFiles({
    required int visitId,
    required List<String> filePaths,
    required String type,
    String? description,
  });
  Future<void> deleteFile({required int visitId, required int imageId});
  Future<void> completeExamination({
    required int visitId,
    required Map<String, dynamic> data,
  });
  Future<Map<String, dynamic>> copyPreviousVisit({
    required int visitId,
    required int prevId,
  });
}

class ExaminationRemoteDataSourceImpl implements ExaminationRemoteDataSource {
  final ApiClient _apiClient;

  const ExaminationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<int> startExamination(int waitingListId) async {
    final response = await _apiClient.dio.post(
      DoctorEndpoints.startExamination(waitingListId),
    );
    final data = _unwrapResponse(response);
    return data['visit_id'] as int;
  }

  @override
  Future<ExaminationModel> getExamination(int visitId) async {
    final response = await _apiClient.dio.get(DoctorEndpoints.examination(visitId));
    final data = _unwrapResponse(response);
    return ExaminationModel.fromJson(data);
  }

  @override
  Future<Map<String, dynamic>> saveSection({
    required int visitId,
    required String section,
    required Map<String, dynamic> data,
  }) async {
    final payload = Map<String, dynamic>.from(data)..['section'] = section;
    final response = await _apiClient.dio.post(
      DoctorEndpoints.saveExaminationSection(visitId),
      data: payload,
    );
    return _unwrapResponse(response);
  }

  @override
  Future<List<VisitImageModel>> uploadFiles({
    required int visitId,
    required List<String> filePaths,
    required String type,
    String? description,
  }) async {
    final formData = FormData();
    for (final path in filePaths) {
      formData.files.add(MapEntry(
        'files[]',
        await MultipartFile.fromFile(path),
      ));
    }
    formData.fields.add(MapEntry('type', type));
    if (description != null && description.isNotEmpty) {
      formData.fields.add(MapEntry('description', description));
    }

    final response = await _apiClient.dio.post(
      DoctorEndpoints.uploadExaminationFiles(visitId),
      data: formData,
    );

    final apiResponse = ApiResponse<dynamic>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => data,
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

    final list = apiResponse.data as List;
    return list
        .map((x) => VisitImageModel.fromJson(Map<String, dynamic>.from(x as Map)))
        .toList();
  }

  @override
  Future<void> deleteFile({required int visitId, required int imageId}) async {
    final response = await _apiClient.dio.delete(
      DoctorEndpoints.deleteExaminationFile(visitId, imageId),
    );
    _unwrapResponse(response);
  }

  @override
  Future<void> completeExamination({
    required int visitId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _apiClient.dio.post(
      DoctorEndpoints.completeExamination(visitId),
      data: data,
    );
    _unwrapResponse(response);
  }

  @override
  Future<Map<String, dynamic>> copyPreviousVisit({
    required int visitId,
    required int prevId,
  }) async {
    final response = await _apiClient.dio.get(
      DoctorEndpoints.copyPreviousVisit(visitId, prevId),
    );
    return _unwrapResponse(response);
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
