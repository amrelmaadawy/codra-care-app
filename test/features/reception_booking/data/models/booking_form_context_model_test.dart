import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/reception_booking/data/models/booking_form_context_model.dart';

void main() {
  final tJson = {
    'server_date': '2026-09-25',
    'server_time': '12:00:00',
    'doctors': [
      {
        'id': 1,
        'name': 'Dr. Tarek',
        'specialization': 'Orthopedics',
        'schedule_mode': 'timed',
        'requires_time': true,
        'daily_limit': 15,
        'default_service_id': 10,
      },
    ],
    'services': [
      {
        'id': 10,
        'name': 'Consultation',
        'price': 300.0,
        'duration_minutes': 20,
        'is_package': false,
        'total_sessions': null,
        'validity_days': null,
      },
    ],
    'questions': [
      {
        'index': 0,
        'text': 'Do you have previous surgeries?',
        'type': 'boolean',
        'options': [],
        'required': true,
      },
    ],
    'availability': {
      'schedule_mode': 'timed',
      'requires_time': true,
      'is_working': true,
      'is_on_leave': false,
      'daily_limit': 15,
      'booked_count': 3,
      'available_count': 12,
      'slots': [
        {
          'value': '10:00:00',
          'label': '10:00 ص',
          'end': '10:20:00',
          'is_booked': false,
        },
      ],
      'message': null,
    },
    'booking_types': [
      {'value': 'first_visit', 'label': 'First Visit'},
    ],
    'capabilities': {
      'can_create_patient': true,
      'can_view_questions': true,
      'can_answer_questions': true,
    },
  };

  test(
    'BookingFormContextModel.fromJson correctly parses nested JSON payload',
    () {
      final model = BookingFormContextModel.fromJson(tJson);

      expect(model.serverDate, '2026-09-25');
      expect(model.doctors.length, 1);
      expect(model.doctors.first.name, 'Dr. Tarek');
      expect(model.services.first.price, 300.0);
      expect(model.questions.first.text, 'Do you have previous surgeries?');
      expect(model.availability?.slots.length, 1);
      expect(model.availability?.slots.first.label, '10:00 ص');
      expect(model.capabilities.canCreatePatient, true);
    },
  );
}
