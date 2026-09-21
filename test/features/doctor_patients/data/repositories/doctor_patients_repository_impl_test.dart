import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/exceptions.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/doctor_patients/data/data_sources/doctor_patients_remote_data_source.dart';
import 'package:medical_erp/features/doctor_patients/data/models/patient_detail_model.dart';
import 'package:medical_erp/features/doctor_patients/data/models/patient_list_result_model.dart';
import 'package:medical_erp/features/doctor_patients/data/models/patient_profile_info_model.dart';
import 'package:medical_erp/features/doctor_patients/data/models/patient_stats_model.dart';
import 'package:medical_erp/features/doctor_patients/data/models/patient_summary_model.dart';
import 'package:medical_erp/features/doctor_patients/data/repositories/doctor_patients_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorPatientsRemoteDataSource extends Mock
    implements DoctorPatientsRemoteDataSource {}

void main() {
  late DoctorPatientsRepositoryImpl repository;
  late MockDoctorPatientsRemoteDataSource mockDataSource;

  const tPatientModel = PatientSummaryModel(
    id: 1,
    name: 'سارة خالد',
    code: 'P-1001',
    totalVisits: 3,
  );

  const tListModel = PatientListResultModel(
    items: [tPatientModel],
    total: 1,
    currentPage: 1,
    lastPage: 1,
  );

  const tDetailModel = PatientDetailModel(
    patient: PatientProfileInfoModel(
      id: 1,
      name: 'سارة خالد',
      code: 'P-1001',
    ),
    stats: PatientStatsModel(
      visitsCount: 3,
      prescriptionsCount: 1,
    ),
    visits: [],
  );

  setUp(() {
    mockDataSource = MockDoctorPatientsRemoteDataSource();
    repository = DoctorPatientsRepositoryImpl(mockDataSource);
  });

  group('getPatients', () {
    test('returns Right(model) on success', () async {
      when(() => mockDataSource.getPatients(search: any(named: 'search'), page: any(named: 'page')))
          .thenAnswer((_) async => tListModel);

      final result = await repository.getPatients();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('should be right'),
        (data) => expect(data.items.length, 1),
      );
    });

    test('returns Left(ServerFailure) on ServerException', () async {
      when(() => mockDataSource.getPatients(search: any(named: 'search'), page: any(named: 'page')))
          .thenThrow(const ServerException(message: 'Server Error', statusCode: 500));

      final result = await repository.getPatients();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, const ServerFailure(message: 'Server Error', statusCode: 500)),
        (_) => fail('should be left'),
      );
    });

    test('returns Left(NetworkFailure) on NetworkException', () async {
      when(() => mockDataSource.getPatients(search: any(named: 'search'), page: any(named: 'page')))
          .thenThrow(const NetworkException());

      final result = await repository.getPatients();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, const NetworkFailure()),
        (_) => fail('should be left'),
      );
    });
  });

  group('getPatientDetail', () {
    test('returns Right(model) on success', () async {
      when(() => mockDataSource.getPatientDetail(1))
          .thenAnswer((_) async => tDetailModel);

      final result = await repository.getPatientDetail(1);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('should be right'),
        (data) => expect(data.patient.name, 'سارة خالد'),
      );
    });

    test('returns Left(NotFoundFailure) on NotFoundException', () async {
      when(() => mockDataSource.getPatientDetail(1))
          .thenThrow(const NotFoundException());

      final result = await repository.getPatientDetail(1);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, const NotFoundFailure()),
        (_) => fail('should be left'),
      );
    });
  });
}
