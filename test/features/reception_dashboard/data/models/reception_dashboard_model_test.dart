import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/reception_dashboard/data/models/appointment_today_stats_model.dart';
import 'package:medical_erp/features/reception_dashboard/data/models/reception_dashboard_model.dart';
import 'package:medical_erp/features/reception_dashboard/data/models/reception_doctor_summary_model.dart';
import 'package:medical_erp/features/reception_dashboard/data/models/reception_queue_item_model.dart';

void main() {
  group('ReceptionDashboard Models Test', () {
    test('AppointmentTodayStatsModel parses valid json correctly', () {
      final json = {
        'scheduled': 10,
        'in_consultation': 3,
        'completed': 8,
        'cancelled': 2,
      };
      final model = AppointmentTodayStatsModel.fromJson(json);
      expect(model.scheduled, 10);
      expect(model.inConsultation, 3);
      expect(model.completed, 8);
      expect(model.cancelled, 2);
      expect(model.total, 23);
    });

    test('ReceptionDoctorSummaryModel supports today_count and todayCount', () {
      final jsonSnake = {'id': 1, 'name': 'د. خالد', 'today_count': 5};
      final model1 = ReceptionDoctorSummaryModel.fromJson(jsonSnake);
      expect(model1.id, 1);
      expect(model1.name, 'د. خالد');
      expect(model1.todayCount, 5);

      final jsonCamel = {'id': 2, 'name': 'د. سارة', 'todayCount': 8};
      final model2 = ReceptionDoctorSummaryModel.fromJson(jsonCamel);
      expect(model2.todayCount, 8);
    });

    test(
      'ReceptionQueueItemModel parses valid json and enforces required fields',
      () {
        final json = {
          'id': 101,
          'ticket_number': 'A-12',
          'patient_id': 201,
          'patient_name': 'محمد أحمد',
          'doctor_id': 5,
          'doctor_name': 'د. حسام',
          'service_name': 'عيادة الباطنة',
          'status': 'waiting',
          'priority': 'urgent',
          'is_present': true,
          'wait_minutes': 25,
        };
        final model = ReceptionQueueItemModel.fromJson(json);
        expect(model.id, 101);
        expect(model.ticketNumber, 'A-12');
        expect(model.patientName, 'محمد أحمد');
        expect(model.isUrgent, true);
        expect(model.waitMinutes, 25);

        // Throws FormatException on missing required ID
        final invalidJson = Map<String, dynamic>.from(json)..remove('id');
        expect(
          () => ReceptionQueueItemModel.fromJson(invalidJson),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test('ReceptionDashboardModel parses full json envelope correctly', () {
      final json = {
        'appointments_today': {
          'scheduled': 5,
          'in_consultation': 2,
          'completed': 3,
          'cancelled': 0,
        },
        'total_patients_today': 10,
        'active_queue': [
          {
            'id': 1,
            'ticket_number': 'T-1',
            'patient_id': 10,
            'patient_name': 'أحمد علي',
            'doctor_id': 2,
            'doctor_name': 'د. سارة',
            'status': 'waiting',
            'priority': 'normal',
            'is_present': true,
            'wait_minutes': 15,
          },
        ],
        'active_waiting_count': 1,
        'pending_follow_ups_count': 4,
        'doctors': [
          {'id': 2, 'name': 'د. سارة', 'today_count': 1},
        ],
        'generated_at': '2026-09-25T12:00:00.000Z',
        'capabilities': {
          'can_view_appointments': true,
          'can_view_queue': true,
          'can_view_follow_ups': true,
        },
      };

      final model = ReceptionDashboardModel.fromJson(json);
      expect(model.appointmentsToday.scheduled, 5);
      expect(model.totalPatientsToday, 10);
      expect(model.activeQueue.length, 1);
      expect(model.activeWaitingCount, 1);
      expect(model.pendingFollowUpsCount, 4);
      expect(model.doctors.length, 1);
      expect(model.capabilities.canViewAppointments, true);
    });
  });
}
