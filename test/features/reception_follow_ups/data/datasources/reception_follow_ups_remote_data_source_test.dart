import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/network/api_client.dart';
import 'package:medical_erp/features/reception_follow_ups/data/datasources/reception_follow_ups_remote_data_source.dart';
import 'package:medical_erp/features/reception_follow_ups/domain/entities/get_follow_ups_params.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockDio extends Mock implements Dio {}

void main() {
  late MockApiClient mockApiClient;
  late MockDio mockDio;
  late ReceptionFollowUpsRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(() => mockApiClient.dio).thenReturn(mockDio);
    dataSource = ReceptionFollowUpsRemoteDataSourceImpl(mockApiClient);
  });

  const tApiResponse = {
    'status': 'success',
    'data': {
      'items': [
        {
          'id': 10,
          'visit_id': 25,
          'visit_number': 'VIS-0025',
          'visit_date': '2026-09-20',
          'patient': {
            'id': 12,
            'full_name': 'Ali Hassan',
            'phone': '01123456789',
            'patient_code': 'P-0012',
          },
          'doctor': {
            'id': 3,
            'name': 'Dr. Sara',
            'specialization': 'Dermatology',
          },
          'service': {
            'id': 1,
            'name': 'Follow-up',
            'price': 100,
            'followup_price': 50,
          },
          'due_date': '2026-09-26',
          'days_delta': 0,
          'urgency': 'today',
          'instructions': 'Routine follow up',
          'capabilities': {
            'can_schedule': true,
          },
        }
      ],
      'summary': {
        'total_pending': 1,
        'overdue_count': 0,
        'today_count': 1,
        'upcoming_count': 0,
      },
      'meta': {
        'current_page': 1,
        'last_page': 1,
        'total': 1,
      },
    },
  };

  group('ReceptionFollowUpsRemoteDataSourceImpl', () {
    test('calls GET endpoint and parses response correctly', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: tApiResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/v1/mobile/reception/follow-ups'),
        ),
      );

      final result = await dataSource.getFollowUps(
        const GetFollowUpsParams(urgency: 'today'),
      );

      expect(result.items.length, 1);
      expect(result.items.first.patientName, 'Ali Hassan');
      expect(result.summary.todayCount, 1);
      expect(result.currentPage, 1);
    });
  });
}
