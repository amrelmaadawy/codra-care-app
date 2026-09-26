import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/endpoints/reception_endpoints.dart';
import '../../domain/entities/create_appointment_params.dart';
import '../../domain/entities/schedule_follow_up_params.dart';
import '../../domain/entities/walk_in_params.dart';
import '../models/booking_appointment_result_model.dart';
import '../models/booking_form_context_model.dart';
import '../models/booking_patient_model.dart';
import '../models/follow_up_schedule_context_model.dart';
import '../models/walk_in_result_model.dart';

abstract class ReceptionBookingRemoteDataSource {
  Future<BookingFormContextModel> getFormContext({int? doctorId, String? date});
  Future<List<BookingPatientModel>> searchPatients(String query);
  Future<BookingAppointmentResultModel> createAppointment(
    CreateAppointmentParams params,
  );
  Future<WalkInResultModel> createWalkIn(WalkInParams params);
  Future<FollowUpScheduleContextModel> getFollowUpScheduleContext(int visitId);
  Future<BookingAppointmentResultModel> scheduleFollowUp(
    ScheduleFollowUpParams params,
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
      return BookingFormContextModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioException(e, 'فشل في تحميل بيانات نموذج الحجز');
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
      final rawItems = response.data['data']?['items'] as List<dynamic>? ?? [];
      return rawItems
          .map((item) =>
              BookingPatientModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioException(e, 'فشل في البحث عن المرضى');
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
      return BookingAppointmentResultModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioException(e, 'فشل في إنشاء الموعد');
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<WalkInResultModel> createWalkIn(WalkInParams params) async {
    try {
      final response = await _dio.post(
        ReceptionEndpoints.walkIn,
        data: params.toJson(),
      );
      return WalkInResultModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioException(e, 'فشل في تسجيل الحالة الفورية');
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<FollowUpScheduleContextModel> getFollowUpScheduleContext(
    int visitId,
  ) async {
    try {
      final response = await _dio.get(
        ReceptionEndpoints.followUpScheduleContext(visitId),
      );
      return FollowUpScheduleContextModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioException(e, 'فشل في تحميل بيانات جدولة المتابعة');
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<BookingAppointmentResultModel> scheduleFollowUp(
    ScheduleFollowUpParams params,
  ) async {
    try {
      final response = await _dio.post(
        ReceptionEndpoints.scheduleFollowUp(params.visitId),
        data: params.toJson(),
      );
      final raw = response.data;
      final apptMap = (raw['data']?['appointment'] ?? raw['appointment'])
          as Map<String, dynamic>;
      return BookingAppointmentResultModel.fromJson(apptMap);
    } on DioException catch (e) {
      throw _handleDioException(e, 'فشل في جدولة موعد المتابعة');
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  ServerException _handleDioException(DioException e, String fallback) {
    final data = e.response?.data;
    String message = fallback;
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
    return ServerException(
      message: message,
      statusCode: e.response?.statusCode ?? 500,
    );
  }
}
