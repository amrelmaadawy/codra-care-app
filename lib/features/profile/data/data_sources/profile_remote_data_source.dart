import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints/doctor_endpoints.dart';
import '../models/doctor_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<DoctorProfileModel> getProfile();

  Future<DoctorProfileModel> updateProfile({
    required String name,
    String? specialization,
    String? phone,
    String? licenseNumber,
  });

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  Future<DoctorProfileModel> updatePhoto(String filePath);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  const ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DoctorProfileModel> getProfile() async {
    final response = await _apiClient.dio.get(DoctorEndpoints.profile);
    final data = _unwrapResponse(response);
    return DoctorProfileModel.fromJson(data);
  }

  @override
  Future<DoctorProfileModel> updateProfile({
    required String name,
    String? specialization,
    String? phone,
    String? licenseNumber,
  }) async {
    final payload = <String, dynamic>{
      'name': name.trim(),
      if (specialization != null) 'specialization': specialization.trim(),
      if (phone != null) 'phone': phone.trim(),
      if (licenseNumber != null) 'license_number': licenseNumber.trim(),
    };

    final response = await _apiClient.dio.put(
      DoctorEndpoints.profile,
      data: payload,
    );
    final data = _unwrapResponse(response);
    return DoctorProfileModel.fromJson(data);
  }

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final payload = <String, dynamic>{
      'current_password': currentPassword,
      'password': newPassword,
      'password_confirmation': confirmPassword,
    };

    final response = await _apiClient.dio.put(
      DoctorEndpoints.profilePassword,
      data: payload,
    );
    _unwrapResponse(response);
  }

  @override
  Future<DoctorProfileModel> updatePhoto(String filePath) async {
    final fileName = filePath.split(RegExp(r'[/\\]')).last;
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(filePath, filename: fileName),
    });

    final response = await _apiClient.dio.post(
      DoctorEndpoints.profilePhoto,
      data: formData,
    );
    final data = _unwrapResponse(response);
    return DoctorProfileModel.fromJson(data);
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
