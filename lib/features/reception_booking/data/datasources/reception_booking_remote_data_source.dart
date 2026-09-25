import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/endpoints/reception_endpoints.dart';
import '../../domain/entities/create_appointment_params.dart';
import '../models/booking_appointment_result_model.dart';
import '../models/booking_form_context_model.dart';
import '../models/booking_patient_model.dart';

abstract class ReceptionBookingRemoteDataSource {
  Future<BookingFormContextModel> getFormContext({int? doctorId, String? date});

  Future<List<BookingPatientModel>> searchPatients(String query);

  Future<BookingAppointmentResultModel> createAppointment(
    CreateAppointmentParams params,
  );
}

class ReceptionBookingRemoteDataSourceImpl
    implements ReceptionBookingRemoteDataSource {
  final Dio _dio;

  const ReceptionBookingRemoteDataSourceImpl({required this._dio});

  @override
  Future<BookingFormContextModel> getFormContext({
    int? doctorId,
    String? date,
  }) async {
    try {
      final response = await _dio.get(
        ReceptionEndpoints.appointmentsFormContext,
        queryParameters: {
          'doctor_id': ?doctorId,
          if (date != null && date.isNotEmpty) 'date': date,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return BookingFormContextModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message'] as String? ??
            'فشل في تحميل بيانات نموذج الحجز',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<List<BookingPatientModel>> searchPatients(String query) async {
    try {
      final response = await _dio.get(
        ReceptionEndpoints.appointmentsPatientSearch,
        queryParameters: {'q': query},
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final rawItems = data['items'] as List<dynamic>? ?? [];
      return rawItems
          .map((i) => BookingPatientModel.fromJson(i as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message'] as String? ?? 'فشل في البحث عن المرضى',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<BookingAppointmentResultModel> createAppointment(
    CreateAppointmentParams params,
  ) async {
    try {
      final response = await _dio.post(
        ReceptionEndpoints.appointments,
        data: params.toJson(),
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return BookingAppointmentResultModel.fromJson(data);
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'فشل في إنشاء الموعد';
      if (data is Map<String, dynamic>) {
        if (data['message'] != null) {
          message = data['message'] as String;
        } else if (data['errors'] != null && data['errors'] is Map) {
          final firstKey = (data['errors'] as Map).keys.first;
          final errList = (data['errors'] as Map)[firstKey];
          if (errList is List && errList.isNotEmpty) {
            message = errList.first.toString();
          }
        }
      }
      throw ServerException(
        message: message,
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
