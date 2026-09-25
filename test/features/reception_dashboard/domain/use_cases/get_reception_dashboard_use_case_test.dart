import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/reception_dashboard/domain/entities/appointment_today_stats_entity.dart';
import 'package:medical_erp/features/reception_dashboard/domain/entities/reception_dashboard_capabilities_entity.dart';
import 'package:medical_erp/features/reception_dashboard/domain/entities/reception_dashboard_entity.dart';
import 'package:medical_erp/features/reception_dashboard/domain/repositories/reception_dashboard_repository.dart';
import 'package:medical_erp/features/reception_dashboard/domain/use_cases/get_reception_dashboard_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockReceptionDashboardRepository extends Mock
    implements ReceptionDashboardRepository {}

void main() {
  late GetReceptionDashboardUseCase useCase;
  late MockReceptionDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockReceptionDashboardRepository();
    useCase = GetReceptionDashboardUseCase(mockRepository);
  });

  const tEntity = ReceptionDashboardEntity(
    appointmentsToday: AppointmentTodayStatsEntity(
      scheduled: 1,
      inConsultation: 0,
      completed: 1,
      cancelled: 0,
    ),
    totalPatientsToday: 2,
    activeQueue: [],
    activeWaitingCount: 0,
    pendingFollowUpsCount: 0,
    doctors: [],
    capabilities: ReceptionDashboardCapabilitiesEntity(
      canViewAppointments: true,
      canViewQueue: true,
      canViewFollowUps: true,
    ),
  );

  test(
    'should return ReceptionDashboardEntity from repository with doctorId',
    () async {
      when(
        () => mockRepository.getDashboard(doctorId: 5),
      ).thenAnswer((_) async => const Right(tEntity));

      final result = await useCase(
        const GetReceptionDashboardParams(doctorId: 5),
      );

      expect(result, const Right(tEntity));
      verify(() => mockRepository.getDashboard(doctorId: 5)).called(1);
    },
  );
}
