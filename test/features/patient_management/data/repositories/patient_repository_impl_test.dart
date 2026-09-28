import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/exceptions.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/patient_management/data/data_sources/patient_remote_data_source.dart';
import 'package:medical_erp/features/patient_management/data/models/patient_list_model.dart';
import 'package:medical_erp/features/patient_management/data/models/patient_page_model.dart';
import 'package:medical_erp/features/patient_management/data/repositories/patient_repository_impl.dart';
import 'package:medical_erp/features/patient_management/domain/entities/patient_list_query.dart';
import 'package:mocktail/mocktail.dart';

class MockPatientRemoteDataSource extends Mock
    implements PatientRemoteDataSource {}

void main() {
  late PatientRepositoryImpl repository;
  late MockPatientRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    registerFallbackValue(const PatientListQuery());
  });

  setUp(() {
    mockRemoteDataSource = MockPatientRemoteDataSource();
    repository = PatientRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tQuery = PatientListQuery();
  const tModel = PatientPageModel(
    items: [
      PatientListModel(
        id: 1,
        code: 'P-1',
        name: 'عمرو',
        phone: '012',
        gender: 'male',
        age: 25,
      ),
    ],
    currentPage: 1,
    lastPage: 1,
    perPage: 20,
    total: 1,
    hasMore: false,
  );

  test('should return Right(PatientPageEntity) on success', () async {
    when(
      () => mockRemoteDataSource.getPatients(
        any(),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => tModel);

    final result = await repository.getPatients(tQuery);

    expect(result.isRight(), isTrue);
    result.fold((_) => fail('Expected Right'), (page) {
      expect(page.items.length, 1);
      expect(page.items.first.name, 'عمرو');
      expect(page.total, 1);
    });
  });

  test(
    'should return Left(Failure) when remoteDataSource throws DioException',
    () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/mobile/patients'),
        error: const NetworkException(),
      );

      when(
        () => mockRemoteDataSource.getPatients(
          any(),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenThrow(dioException);

      final result = await repository.getPatients(tQuery);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    },
  );
}
