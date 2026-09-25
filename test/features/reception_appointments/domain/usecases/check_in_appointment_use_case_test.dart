import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/reception_appointments/domain/entities/check_in_result_entity.dart';
import 'package:medical_erp/features/reception_appointments/domain/repositories/appointment_repository.dart';
import 'package:medical_erp/features/reception_appointments/domain/usecases/check_in_appointment_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAppointmentRepository extends Mock
    implements AppointmentRepository {}

void main() {
  late CheckInAppointmentUseCase useCase;
  late MockAppointmentRepository mockRepository;

  setUp(() {
    mockRepository = MockAppointmentRepository();
    useCase = CheckInAppointmentUseCase(mockRepository);
  });

  const tResult = CheckInResultEntity(
    appointmentId: 10,
    queueItemId: 5,
    ticketNumber: 'A-01',
    patientName: 'John Doe',
    doctorName: 'Dr. Smith',
    status: 'waiting',
    priority: 'normal',
    alreadyCheckedIn: false,
  );

  test('delegates call to repository.checkInAppointment with correct params', () async {
    when(
      () => mockRepository.checkInAppointment(
        appointmentId: 10,
        priority: 'urgent',
        clientRequestId: 'req-uuid',
      ),
    ).thenAnswer((_) async => const Right(tResult));

    final result = await useCase(
      appointmentId: 10,
      priority: 'urgent',
      clientRequestId: 'req-uuid',
    );

    expect(result, const Right(tResult));
    verify(
      () => mockRepository.checkInAppointment(
        appointmentId: 10,
        priority: 'urgent',
        clientRequestId: 'req-uuid',
      ),
    ).called(1);
  });

  test('returns failure when repository fails', () async {
    const tFailure = ServerFailure(message: 'Already checked in');
    when(
      () => mockRepository.checkInAppointment(
        appointmentId: 10,
        priority: 'normal',
      ),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await useCase(appointmentId: 10);

    expect(result, const Left(tFailure));
  });
}
