import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/exceptions.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/reception_payments/data/data_sources/reception_payments_remote_data_source.dart';
import 'package:medical_erp/features/reception_payments/data/models/financial_capabilities_model.dart';
import 'package:medical_erp/features/reception_payments/data/models/financial_currency_model.dart';
import 'package:medical_erp/features/reception_payments/data/models/financial_snapshot_model.dart';
import 'package:medical_erp/features/reception_payments/data/models/financial_summary_model.dart';
import 'package:medical_erp/features/reception_payments/data/models/payment_action_result_model.dart';
import 'package:medical_erp/features/reception_payments/data/repositories/reception_payments_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockReceptionPaymentsRemoteDataSource extends Mock
    implements ReceptionPaymentsRemoteDataSource {}

void main() {
  late MockReceptionPaymentsRemoteDataSource mockRemoteDataSource;
  late ReceptionPaymentsRepositoryImpl repository;

  const tSnapshotModel = FinancialSnapshotModel(
    appointmentId: 10,
    currency: FinancialCurrencyModel(code: 'EGP', symbol: 'ج.م', decimals: 2),
    summary: FinancialSummaryModel(
      grossCharges: '300.00',
      discountTotal: '0.00',
      netDue: '300.00',
      payments: '0.00',
      refunds: '0.00',
      balance: '300.00',
      maxPayable: '300.00',
      maxRefundable: '0.00',
      maxDiscount: '300.00',
      financialStatus: 'unpaid',
      financialVersion: 1,
    ),
    capabilities: FinancialCapabilitiesModel(canPay: true),
    charges: [],
    transactions: [],
    paymentMethods: [],
    bankAccounts: [],
  );

  setUp(() {
    mockRemoteDataSource = MockReceptionPaymentsRemoteDataSource();
    repository = ReceptionPaymentsRepositoryImpl(mockRemoteDataSource);
  });

  group('getFinancialSnapshot', () {
    test('returns Right(FinancialSnapshotEntity) on remote success', () async {
      when(() => mockRemoteDataSource.getFinancialSnapshot(10))
          .thenAnswer((_) async => tSnapshotModel);

      final result = await repository.getFinancialSnapshot(10);

      expect(result, const Right(tSnapshotModel));
      verify(() => mockRemoteDataSource.getFinancialSnapshot(10)).called(1);
    });

    test('returns Left(ServerFailure) on ServerException', () async {
      when(() => mockRemoteDataSource.getFinancialSnapshot(10))
          .thenThrow(const ServerException(message: 'Server Error', statusCode: 500));

      final result = await repository.getFinancialSnapshot(10);

      expect(result, isA<Left<Failure, dynamic>>());
    });
  });

  group('addPayments', () {
    test('returns Right(PaymentActionResultEntity) on success', () async {
      const tResult = PaymentActionResultModel(
        success: true,
        message: 'Payment recorded',
      );
      when(() => mockRemoteDataSource.addPayments(
            appointmentId: 10,
            expectedFinancialVersion: 1,
            payments: [],
            clientRequestId: 'req-1',
          )).thenAnswer((_) async => tResult);

      final result = await repository.addPayments(
        appointmentId: 10,
        expectedFinancialVersion: 1,
        payments: [],
        clientRequestId: 'req-1',
      );

      expect(result, const Right(tResult));
    });
  });
}
