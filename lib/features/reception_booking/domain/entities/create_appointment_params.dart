import 'package:equatable/equatable.dart';

class NewPatientParams extends Equatable {
  final String fullName;
  final String phone;
  final String gender;
  final int? age;
  final String? address;

  const NewPatientParams({
    required this.fullName,
    required this.phone,
    required this.gender,
    this.age,
    this.address,
  });

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'phone': phone,
    'gender': gender,
    if (age != null) 'age': age,
    if (address != null && address!.isNotEmpty) 'address': address,
  };

  @override
  List<Object?> get props => [fullName, phone, gender, age, address];
}

class CreateAppointmentParams extends Equatable {
  final int doctorId;
  final int serviceId;
  final String appointmentDate;
  final String? appointmentTime;
  final String bookingType;
  final int? patientId;
  final NewPatientParams? newPatient;
  final String? notes;
  final Map<String, dynamic> questionAnswers;

  const CreateAppointmentParams({
    required this.doctorId,
    required this.serviceId,
    required this.appointmentDate,
    this.appointmentTime,
    required this.bookingType,
    this.patientId,
    this.newPatient,
    this.notes,
    this.questionAnswers = const {},
  });

  Map<String, dynamic> toJson() => {
    'doctor_id': doctorId,
    'service_id': serviceId,
    'appointment_date': appointmentDate,
    if (appointmentTime != null && appointmentTime!.isNotEmpty)
      'appointment_time': appointmentTime,
    'booking_type': bookingType,
    if (patientId != null) 'patient_id': patientId,
    if (newPatient != null) 'new_patient': newPatient!.toJson(),
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
    if (questionAnswers.isNotEmpty) 'question_answers': questionAnswers,
  };

  @override
  List<Object?> get props => [
    doctorId,
    serviceId,
    appointmentDate,
    appointmentTime,
    bookingType,
    patientId,
    newPatient,
    notes,
    questionAnswers,
  ];
}
