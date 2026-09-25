import 'package:equatable/equatable.dart';
import 'booking_availability_entity.dart';
import 'booking_doctor_entity.dart';
import 'booking_question_entity.dart';
import 'booking_service_entity.dart';
import 'booking_types_and_capabilities.dart';

class BookingFormContextEntity extends Equatable {
  final String serverDate;
  final String serverTime;
  final List<BookingDoctorEntity> doctors;
  final List<BookingServiceEntity> services;
  final List<BookingQuestionEntity> questions;
  final BookingAvailabilityEntity? availability;
  final List<BookingTypeEntity> bookingTypes;
  final BookingCapabilitiesEntity capabilities;

  const BookingFormContextEntity({
    required this.serverDate,
    required this.serverTime,
    required this.doctors,
    required this.services,
    required this.questions,
    this.availability,
    required this.bookingTypes,
    required this.capabilities,
  });

  @override
  List<Object?> get props => [
    serverDate,
    serverTime,
    doctors,
    services,
    questions,
    availability,
    bookingTypes,
    capabilities,
  ];
}
