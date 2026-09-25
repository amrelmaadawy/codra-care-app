import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/reception_appointments/data/models/appointment_model.dart';
import 'package:medical_erp/features/reception_appointments/domain/entities/appointment_enums.dart';

void main() {
  final tJson = {
    'id': 15,
    'appointment_number': 'APT-1001',
    'appointment_date': '2026-09-25',
    'start_time': '10:00:00',
    'end_time': '10:15:00',
    'queue_position': 1,
    'status': 'scheduled',
    'booking_type': 'first_visit',
    'booking_mode': 'scheduled',
    'service_price': 250.0,
    'cancellation_reason': null,
    'patient': {
      'id': 101,
      'full_name': 'Ali Hassan',
      'patient_code': 'P-001',
      'phone': '01234567890',
    },
    'doctor': {'id': 5, 'name': 'Dr. Mona', 'specialization': 'Pediatrics'},
    'service': {
      'id': 12,
      'name': 'Checkup',
      'price': 250.0,
      'duration_minutes': 15,
      'is_package': false,
    },
    'capabilities': {'can_cancel': true},
  };

  test('AppointmentModel.fromJson correctly parses full JSON payload', () {
    final model = AppointmentModel.fromJson(tJson);

    expect(model.id, 15);
    expect(model.appointmentNumber, 'APT-1001');
    expect(model.appointmentDate, '2026-09-25');
    expect(model.startTime, '10:00:00');
    expect(model.status, AppointmentStatus.scheduled);
    expect(model.bookingType, BookingType.firstVisit);
    expect(model.bookingMode, AppointmentBookingMode.scheduled);
    expect(model.patient.fullName, 'Ali Hassan');
    expect(model.doctor.name, 'Dr. Mona');
    expect(model.service?.price, 250.0);
    expect(model.canCancel, true);
  });
}
