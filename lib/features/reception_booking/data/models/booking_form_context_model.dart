import '../../domain/entities/booking_form_context_entity.dart';
import '../../domain/entities/booking_types_and_capabilities.dart';
import 'booking_availability_model.dart';
import 'booking_doctor_model.dart';
import 'booking_question_model.dart';
import 'booking_service_model.dart';

class BookingFormContextModel extends BookingFormContextEntity {
  const BookingFormContextModel({
    required super.serverDate,
    required super.serverTime,
    required super.doctors,
    required super.services,
    required super.questions,
    super.availability,
    required super.bookingTypes,
    required super.capabilities,
  });

  factory BookingFormContextModel.fromJson(Map<String, dynamic> json) {
    final rawDocs = json['doctors'] as List<dynamic>? ?? [];
    final doctors = rawDocs
        .map((d) => BookingDoctorModel.fromJson(d as Map<String, dynamic>))
        .toList();

    final rawServices = json['services'] as List<dynamic>? ?? [];
    final services = rawServices
        .map((s) => BookingServiceModel.fromJson(s as Map<String, dynamic>))
        .toList();

    final rawQuestions = json['questions'] as List<dynamic>? ?? [];
    final questions = rawQuestions
        .map((q) => BookingQuestionModel.fromJson(q as Map<String, dynamic>))
        .toList();

    BookingAvailabilityModel? availability;
    if (json['availability'] != null && json['availability'] is Map) {
      availability = BookingAvailabilityModel.fromJson(
        json['availability'] as Map<String, dynamic>,
      );
    }

    final rawTypes = json['booking_types'] as List<dynamic>? ?? [];
    final bookingTypes = rawTypes.map((t) {
      final map = t as Map<String, dynamic>;
      return BookingTypeEntity(
        value: (map['value'] ?? '') as String,
        label: (map['label'] ?? '') as String,
      );
    }).toList();

    final rawCaps = json['capabilities'] as Map<String, dynamic>? ?? {};
    final capabilities = BookingCapabilitiesEntity(
      canCreatePatient: rawCaps['can_create_patient'] as bool? ?? true,
      canViewQuestions: rawCaps['can_view_questions'] as bool? ?? true,
      canAnswerQuestions: rawCaps['can_answer_questions'] as bool? ?? true,
    );

    return BookingFormContextModel(
      serverDate: (json['server_date'] ?? '') as String,
      serverTime: (json['server_time'] ?? '') as String,
      doctors: doctors,
      services: services,
      questions: questions,
      availability: availability,
      bookingTypes: bookingTypes,
      capabilities: capabilities,
    );
  }
}
