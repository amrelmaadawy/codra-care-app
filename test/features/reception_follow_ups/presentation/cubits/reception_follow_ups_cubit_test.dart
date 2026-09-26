import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/reception_follow_ups/domain/entities/follow_up_summary_entity.dart';
import 'package:medical_erp/features/reception_follow_ups/domain/entities/follow_ups_page_entity.dart';
import 'package:medical_erp/features/reception_follow_ups/domain/entities/get_follow_ups_params.dart';
import 'package:medical_erp/features/reception_follow_ups/domain/entities/reception_follow_up_entity.dart';
import 'package:medical_erp/features/reception_follow_ups/domain/usecases/get_follow_ups_use_case.dart';
import 'package:medical_erp/features/reception_follow_ups/presentation/cubits/reception_follow_ups_cubit.dart';
import 'package:medical_erp/features/reception_follow_ups/presentation/cubits/reception_follow_ups_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFollowUpsUseCase extends Mock implements GetFollowUpsUseCase {}

void main() {
  late MockGetFollowUpsUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(const GetFollowUpsParams());
  });

  setUp(() {
    mockUseCase = MockGetFollowUpsUseCase();
  });

  const tItem = ReceptionFollowUpEntity(
    id: 101,
    visitId: 50,
    visitNumber: 'VIS-001',
    patientId: 10,
    patientName: 'John Doe',
    patientPhone: '01012345678',
    doctorId: 5,
    doctorName: 'Dr. Smith',
    doctorSpecialization: 'Cardiology',
    serviceName: 'Follow-up Consultation',
    servicePrice: 150.0,
    dueDate: '2026-09-26',
    daysDelta: 0,
    urgency: FollowUpUrgency.today,
    instructions: 'Re-evaluate blood pressure',
    canSchedule: true,
  );

  const tSummary = FollowUpSummaryEntity(
    totalPending: 3,
    overdueCount: 1,
    todayCount: 1,
    upcomingCount: 1,
  );

  const tPage = FollowUpsPageEntity(
    items: [tItem],
    summary: tSummary,
    currentPage: 1,
    lastPage: 1,
    total: 1,
  );

  group('ReceptionFollowUpsCubit', () {
    test('initial state has correct default values', () {
      final cubit = ReceptionFollowUpsCubit(mockUseCase);
      expect(cubit.state, const ReceptionFollowUpsState());
      cubit.close();
    });

    blocTest<ReceptionFollowUpsCubit, ReceptionFollowUpsState>(
      'emits [loading, success] when loadFollowUps succeeds',
      build: () {
        when(() => mockUseCase(any())).thenAnswer((_) async => const Right(tPage));
        return ReceptionFollowUpsCubit(mockUseCase);
      },
      act: (cubit) => cubit.loadFollowUps(),
      expect: () => [
        const ReceptionFollowUpsState(
          status: FollowUpsStatus.loading,
          requestGeneration: 1,
        ),
        const ReceptionFollowUpsState(
          status: FollowUpsStatus.success,
          requestGeneration: 1,
          items: [tItem],
          summary: tSummary,
        ),
      ],
      verify: (_) {
        verify(() => mockUseCase(any())).called(1);
      },
    );

    blocTest<ReceptionFollowUpsCubit, ReceptionFollowUpsState>(
      'emits [loading, error] when loadFollowUps fails',
      build: () {
        when(() => mockUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));
        return ReceptionFollowUpsCubit(mockUseCase);
      },
      act: (cubit) => cubit.loadFollowUps(),
      expect: () => [
        const ReceptionFollowUpsState(
          status: FollowUpsStatus.loading,
          requestGeneration: 1,
        ),
        const ReceptionFollowUpsState(
          status: FollowUpsStatus.error,
          requestGeneration: 1,
          errorMessage: 'Server error',
        ),
      ],
    );

    blocTest<ReceptionFollowUpsCubit, ReceptionFollowUpsState>(
      'setUrgency updates params and triggers reload',
      build: () {
        when(() => mockUseCase(any())).thenAnswer((_) async => const Right(tPage));
        return ReceptionFollowUpsCubit(mockUseCase);
      },
      act: (cubit) => cubit.setUrgency('overdue'),
      expect: () => [
        const ReceptionFollowUpsState(
          params: GetFollowUpsParams(urgency: 'overdue'),
        ),
        const ReceptionFollowUpsState(
          status: FollowUpsStatus.loading,
          requestGeneration: 1,
          params: GetFollowUpsParams(urgency: 'overdue'),
        ),
        const ReceptionFollowUpsState(
          status: FollowUpsStatus.success,
          requestGeneration: 1,
          items: [tItem],
          summary: tSummary,
          params: GetFollowUpsParams(urgency: 'overdue'),
        ),
      ],
    );

    test('toggleInstructions expands and collapses item', () {
      final cubit = ReceptionFollowUpsCubit(mockUseCase);
      expect(cubit.state.expandedItemIds, isEmpty);

      cubit.toggleInstructions(101);
      expect(cubit.state.expandedItemIds, contains(101));

      cubit.toggleInstructions(101);
      expect(cubit.state.expandedItemIds, isEmpty);

      cubit.close();
    });
  });
}
