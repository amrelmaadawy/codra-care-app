enum AppointmentStatus {
  scheduled,
  inConsultation,
  completed,
  cancelled,
  unknown;

  static AppointmentStatus fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'scheduled' => AppointmentStatus.scheduled,
      'in_consultation' => AppointmentStatus.inConsultation,
      'completed' => AppointmentStatus.completed,
      'cancelled' => AppointmentStatus.cancelled,
      _ => AppointmentStatus.unknown,
    };
  }

  String toApiValue() {
    return switch (this) {
      AppointmentStatus.scheduled => 'scheduled',
      AppointmentStatus.inConsultation => 'in_consultation',
      AppointmentStatus.completed => 'completed',
      AppointmentStatus.cancelled => 'cancelled',
      AppointmentStatus.unknown => 'scheduled',
    };
  }
}

enum BookingType {
  firstVisit,
  followUp,
  routineCheck,
  urgent,
  unknown;

  static BookingType fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'first_visit' => BookingType.firstVisit,
      'follow_up' => BookingType.followUp,
      'routine_check' => BookingType.routineCheck,
      'urgent' => BookingType.urgent,
      _ => BookingType.unknown,
    };
  }

  String toApiValue() {
    return switch (this) {
      BookingType.firstVisit => 'first_visit',
      BookingType.followUp => 'follow_up',
      BookingType.routineCheck => 'routine_check',
      BookingType.urgent => 'urgent',
      BookingType.unknown => 'first_visit',
    };
  }
}

enum AppointmentBookingMode {
  scheduled,
  instant,
  unknown;

  static AppointmentBookingMode fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'scheduled' => AppointmentBookingMode.scheduled,
      'instant' => AppointmentBookingMode.instant,
      _ => AppointmentBookingMode.unknown,
    };
  }
}
