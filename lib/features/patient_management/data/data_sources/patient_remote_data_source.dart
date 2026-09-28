import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints/patient_endpoints.dart';
import '../../domain/entities/patient_list_query.dart';
import '../models/patient_page_model.dart';

abstract class PatientRemoteDataSource {
  Future<PatientPageModel> getPatients(
    PatientListQuery query, {
    CancelToken? cancelToken,
  });
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final Dio _dio;

  PatientRemoteDataSourceImpl({Dio? dio})
    : _dio = dio ?? ApiClient.instance.dio;

  @override
  Future<PatientPageModel> getPatients(
    PatientListQuery query, {
    CancelToken? cancelToken,
  }) async {
    final queryParams = <String, dynamic>{'page': query.page};
    if (query.search != null && query.search!.trim().isNotEmpty) {
      queryParams['search'] = query.search!.trim();
    }

    final response = await _dio.get(
      PatientEndpoints.patients,
      queryParameters: queryParams,
      cancelToken: cancelToken,
    );

    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      return PatientPageModel.fromJson(rawData);
    }
    throw const FormatException('Invalid JSON payload structure');
  }
}
