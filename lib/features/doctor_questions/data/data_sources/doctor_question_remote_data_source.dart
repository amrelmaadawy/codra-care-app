import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/doctor_endpoints.dart';
import '../../domain/entities/doctor_question_entity.dart';
import '../models/doctor_question_model.dart';

abstract class DoctorQuestionRemoteDataSource {
  Future<List<DoctorQuestionModel>> getQuestions();

  Future<DoctorQuestionModel> createQuestion({
    required String text,
    required DoctorQuestionType type,
    List<String>? options,
    required bool isRequired,
    bool isActive = true,
  });

  Future<DoctorQuestionModel> updateQuestion({
    required int id,
    required String text,
    required DoctorQuestionType type,
    List<String>? options,
    required bool isRequired,
  });

  Future<void> deleteQuestion(int id);

  Future<DoctorQuestionModel> toggleQuestion(int id);

  Future<void> reorderQuestions(List<int> orderedIds);
}

class DoctorQuestionRemoteDataSourceImpl
    implements DoctorQuestionRemoteDataSource {
  final ApiClient _apiClient;

  const DoctorQuestionRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<DoctorQuestionModel>> getQuestions() async {
    final response = await _apiClient.dio.get(DoctorEndpoints.questions);
    final list = _unwrapListResponse(response);
    return list.map(DoctorQuestionModel.fromJson).toList();
  }

  @override
  Future<DoctorQuestionModel> createQuestion({
    required String text,
    required DoctorQuestionType type,
    List<String>? options,
    required bool isRequired,
    bool isActive = true,
  }) async {
    final body = <String, dynamic>{
      'question_text': text.trim(),
      'question_type': type.toApiString(),
      'is_required': isRequired,
      'is_active': isActive,
    };
    if (type == DoctorQuestionType.multipleChoice && options != null) {
      body['options'] = options.where((o) => o.trim().isNotEmpty).toList();
    }

    final response = await _apiClient.dio.post(
      DoctorEndpoints.questions,
      data: body,
    );
    final data = _unwrapResponse(response);
    return DoctorQuestionModel.fromJson(data);
  }

  @override
  Future<DoctorQuestionModel> updateQuestion({
    required int id,
    required String text,
    required DoctorQuestionType type,
    List<String>? options,
    required bool isRequired,
  }) async {
    final body = <String, dynamic>{
      'question_text': text.trim(),
      'question_type': type.toApiString(),
      'is_required': isRequired,
    };
    if (type == DoctorQuestionType.multipleChoice && options != null) {
      body['options'] = options.where((o) => o.trim().isNotEmpty).toList();
    }

    final response = await _apiClient.dio.put(
      DoctorEndpoints.questionDetail(id),
      data: body,
    );
    final data = _unwrapResponse(response);
    return DoctorQuestionModel.fromJson(data);
  }

  @override
  Future<void> deleteQuestion(int id) async {
    final response = await _apiClient.dio.delete(
      DoctorEndpoints.questionDetail(id),
    );
    _unwrapResponse(response);
  }

  @override
  Future<DoctorQuestionModel> toggleQuestion(int id) async {
    final response = await _apiClient.dio.patch(
      DoctorEndpoints.questionToggle(id),
    );
    final data = _unwrapResponse(response);
    return DoctorQuestionModel.fromJson(data);
  }

  @override
  Future<void> reorderQuestions(List<int> orderedIds) async {
    final response = await _apiClient.dio.post(
      DoctorEndpoints.questionsReorder,
      data: {'order': orderedIds},
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
