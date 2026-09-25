import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints/reception_endpoints.dart';
import '../../domain/entities/appointment_enums.dart';
import '../../domain/entities/appointment_filters.dart';
import '../models/appointment_calendar_day_model.dart';
import '../models/appointment_model.dart';
import '../models/appointments_page_model.dart';
import '../models/check_in_result_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<AppointmentsPageModel> getAppointments({
    required AppointmentFilters filters,
    int page = 1,
    int perPage = 20,
  });

  Future<List<AppointmentCalendarDayModel>> getCalendarEvents({
    required String month,
    int? doctorId,
    AppointmentStatus? status,
  });

  Future<AppointmentModel> cancelAppointment({
    required int appointmentId,
    required String reason,
  });

  Future<CheckInResultModel> checkInAppointment({
    required int appointmentId,
    String priority = 'normal',
    String? clientRequestId,
  });
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final ApiClient apiClient;

  const AppointmentRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AppointmentsPageModel> getAppointments({
    required AppointmentFilters filters,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'date': filters.date,
      'page': page,
      'per_page': perPage,
    };
    if (filters.doctorId != null) {
      queryParams['doctor_id'] = filters.doctorId;
    }
    if (filters.status != null && filters.status != AppointmentStatus.unknown) {
      queryParams['status'] = filters.status!.toApiValue();
    }

    final response = await apiClient.dio.get(
      ReceptionEndpoints.appointments,
      queryParameters: queryParams,
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return AppointmentsPageModel.fromJson(data);
  }

  @override
  Future<List<AppointmentCalendarDayModel>> getCalendarEvents({
    required String month,
    int? doctorId,
    AppointmentStatus? status,
  }) async {
    final queryParams = <String, dynamic>{'month': month};
    if (doctorId != null) {
      queryParams['doctor_id'] = doctorId;
    }
    if (status != null && status != AppointmentStatus.unknown) {
      queryParams['status'] = status.toApiValue();
    }

    final response = await apiClient.dio.get(
      ReceptionEndpoints.appointmentsCalendar,
      queryParameters: queryParams,
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final daysList = (data['days'] as List<dynamic>?) ?? [];
    return daysList
        .map(
          (d) =>
              AppointmentCalendarDayModel.fromJson(d as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<AppointmentModel> cancelAppointment({
    required int appointmentId,
    required String reason,
  }) async {
    final response = await apiClient.dio.post(
      ReceptionEndpoints.cancelAppointment(appointmentId),
      data: {'cancellation_reason': reason},
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return AppointmentModel.fromJson(data);
  }

  @override
  Future<CheckInResultModel> checkInAppointment({
    required int appointmentId,
    String priority = 'normal',
    String? clientRequestId,
  }) async {
    final response = await apiClient.dio.post(
      ReceptionEndpoints.checkInAppointment(appointmentId),
      data: {
        'priority': priority,
        'client_request_id': ?clientRequestId,
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return CheckInResultModel.fromJson(data);
  }
}
