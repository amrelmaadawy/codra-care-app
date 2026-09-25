import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/reception_dashboard/domain/entities/appointment_today_stats_entity.dart';
import 'package:medical_erp/features/reception_dashboard/domain/entities/reception_dashboard_capabilities_entity.dart';
import 'package:medical_erp/features/reception_dashboard/domain/entities/reception_dashboard_entity.dart';
import 'package:medical_erp/features/reception_dashboard/domain/entities/reception_doctor_summary_entity.dart';
import 'package:medical_erp/features/reception_dashboard/domain/entities/reception_queue_item_entity.dart';
import 'package:medical_erp/features/reception_dashboard/presentation/cubits/reception_dashboard_cubit.dart';
import 'package:medical_erp/features/reception_dashboard/presentation/cubits/reception_dashboard_state.dart';
import 'package:medical_erp/features/reception_dashboard/presentation/views/reception_dashboard_view.dart';
import 'package:medical_erp/features/reception_dashboard/presentation/widgets/reception_dashboard_shimmer.dart';
import 'package:mocktail/mocktail.dart';

class MockReceptionDashboardCubit extends MockCubit<ReceptionDashboardState>
    implements ReceptionDashboardCubit {}

void main() {
  late MockReceptionDashboardCubit mockCubit;

  setUp(() {
    mockCubit = MockReceptionDashboardCubit();
  });

  const tEntity = ReceptionDashboardEntity(
    appointmentsToday: AppointmentTodayStatsEntity(
      scheduled: 5,
      inConsultation: 2,
      completed: 3,
      cancelled: 1,
    ),
    totalPatientsToday: 11,
    activeQueue: [
      ReceptionQueueItemEntity(
        id: 1,
        ticketNumber: 'A-01',
        patientId: 10,
        patientName: 'أحمد محمود',
        doctorId: 2,
        doctorName: 'د. سارة',
        serviceName: 'كشف عام',
        status: 'waiting',
        priority: 'urgent',
        isPresent: true,
        waitMinutes: 20,
      ),
    ],
    activeWaitingCount: 1,
    pendingFollowUpsCount: 3,
    doctors: [
      ReceptionDoctorSummaryEntity(id: 2, name: 'د. سارة', todayCount: 1),
    ],
    capabilities: ReceptionDashboardCapabilitiesEntity(
      canViewAppointments: true,
      canViewQueue: true,
      canViewFollowUps: true,
    ),
  );

  Widget createWidgetUnderTest(ReceptionDashboardState state) {
    when(() => mockCubit.state).thenReturn(state);
    when(() => mockCubit.stream).thenAnswer((_) => Stream.value(state));

    return MaterialApp(
      home: BlocProvider<ReceptionDashboardCubit>.value(
        value: mockCubit,
        child: const ReceptionDashboardView(),
      ),
    );
  }

  testWidgets(
    'renders ReceptionDashboardShimmer on Loading with zero circular spinners',
    (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(const ReceptionDashboardLoading()),
      );

      expect(find.byType(ReceptionDashboardShimmer), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
    },
  );

  testWidgets(
    'renders loaded dashboard on narrow 320px width without circular spinners or overflow',
    (tester) async {
      FlutterErrorDetails? caughtDetails;
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        caughtDetails = details;
      };
      addTearDown(() => FlutterError.onError = originalOnError);

      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createWidgetUnderTest(const ReceptionDashboardLoaded(data: tEntity)),
      );
      await tester.pumpAndSettle();

      expect(find.text('أحمد محمود'), findsOneWidget);
      expect(find.text('A-01'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
      expect(caughtDetails, isNull);
    },
  );
}
