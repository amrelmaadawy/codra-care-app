import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/reception_appointments/domain/entities/appointment_calendar_day_entity.dart';
import 'package:medical_erp/features/reception_appointments/presentation/widgets/appointments_calendar_bar.dart';
import 'package:medical_erp/features/reception_appointments/presentation/widgets/appointment_list_shimmer.dart';

void main() {
  testWidgets(
    'Zero Circular Spinner Rule: AppointmentListShimmer contains no circular indicators',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppointmentListShimmer())),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'Responsive Test: AppointmentsCalendarBar renders cleanly at 320px width',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppointmentsCalendarBar(
              selectedDate: '2026-09-25',
              currentMonth: '2026-09',
              calendarDays: const [
                AppointmentCalendarDayEntity(
                  date: '2026-09-25',
                  total: 5,
                  scheduledCount: 3,
                  inConsultationCount: 1,
                  completedCount: 1,
                ),
              ],
              isExpanded: false,
              onDateSelected: (_) {},
              onMonthChanged: (_) {},
              onToggleExpand: () {},
            ),
          ),
        ),
      );

      expect(find.byType(AppointmentsCalendarBar), findsOneWidget);
      expect(find.text('25'), findsAtLeastNWidgets(1));
      expect(tester.takeException(), isNull);
    },
  );
}
