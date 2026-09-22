import '../../domain/entities/doctor_visit_report_entity.dart';

class DoctorVisitReportModel extends DoctorVisitReportEntity {
  const DoctorVisitReportModel({
    required super.id,
    required super.visitNumber,
    required super.patientId,
    required super.patientName,
    required super.patientPhone,
    required super.serviceName,
    required super.servicePrice,
    required super.doctorEarning,
    super.visitDate,
    required super.status,
  });

  factory DoctorVisitReportModel.fromJson(Map<String, dynamic> json) {
    return DoctorVisitReportModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      visitNumber: json['visit_number'] as String? ?? '',
      patientId: (json['patient_id'] as num?)?.toInt() ?? 0,
      patientName: json['patient_name'] as String? ?? '—',
      patientPhone: json['patient_phone'] as String? ?? '',
      serviceName: json['service_name'] as String? ?? 'كشف عام',
      servicePrice: (json['service_price'] as num?)?.toDouble() ?? 0.0,
      doctorEarning: (json['doctor_earning'] as num?)?.toDouble() ?? 0.0,
      visitDate: json['visit_date'] as String?,
      status: json['status'] as String? ?? 'completed',
    );
  }
}
