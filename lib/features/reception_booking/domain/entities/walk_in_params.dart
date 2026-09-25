import 'package:equatable/equatable.dart';
import 'create_appointment_params.dart';

class WalkInParams extends Equatable {
  final String clientRequestId;
  final int? patientId;
  final NewPatientParams? newPatient;
  final int doctorId;
  final int serviceId;
  final String bookingType;
  final String priority;
  final String? notes;
  final String? questionsVersion;
  final List<dynamic>? answers;
  final Map<String, dynamic>? vitalSigns;

  const WalkInParams({
    required this.clientRequestId,
    this.patientId,
    this.newPatient,
    required this.doctorId,
    required this.serviceId,
    this.bookingType = 'first_visit',
    this.priority = 'normal',
    this.notes,
    this.questionsVersion,
    this.answers,
    this.vitalSigns,
  });

  Map<String, dynamic> toJson() => {
    'client_request_id': clientRequestId,
    if (patientId != null) 'patient_id': patientId,
    if (newPatient != null) 'new_patient': newPatient!.toJson(),
    'doctor_id': doctorId,
    'service_id': serviceId,
    'booking_type': bookingType,
    'priority': priority,
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
    if (questionsVersion != null) 'questions_version': questionsVersion,
    if (answers != null && answers!.isNotEmpty) 'answers': answers,
    if (vitalSigns != null && vitalSigns!.isNotEmpty) 'vital_signs': vitalSigns,
  };

  @override
  List<Object?> get props => [
    clientRequestId,
    patientId,
    newPatient,
    doctorId,
    serviceId,
    bookingType,
    priority,
    notes,
    questionsVersion,
    answers,
    vitalSigns,
  ];
}
