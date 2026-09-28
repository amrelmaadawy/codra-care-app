import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/reception_payments/domain/entities/financial_capabilities_entity.dart';
import 'package:medical_erp/features/reception_payments/domain/entities/financial_currency_entity.dart';
import 'package:medical_erp/features/reception_payments/domain/entities/financial_snapshot_entity.dart';
import 'package:medical_erp/features/reception_payments/domain/entities/financial_summary_entity.dart';
import 'package:medical_erp/features/reception_payments/domain/entities/payment_action_result_entity.dart';
import 'package:medical_erp/features/reception_payments/domain/use_cases/add_appointment_service_use_case.dart';
import 'package:medical_erp/features/reception_payments/domain/use_cases/add_discount_use_case.dart';
import 'package:medical_erp/features/reception_payments/domain/use_cases/add_payments_use_case.dart';
import 'package:medical_erp/features/reception_payments/domain/use_cases/add_refund_use_case.dart';
import 'package:medical_erp/features/reception_payments/domain/use_cases/get_financial_snapshot_use_case.dart';
import 'package:medical_erp/features/reception_payments/presentation/cubits/reception_payment_cubit.dart';
import 'package:medical_erp/features/reception_payments/presentation/cubits/reception_payment_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFinancialSnapshotUseCase extends Mock
    implements GetFinancialSnapshotUseCase {}

class MockAddPaymentsUseCase extends Mock implements AddPaymentsUseCase {}

class MockAddRefundUseCase extends Mock implements AddRefundUseCase {}

class MockAddDiscountUseCase extends Mock implements AddDiscountUseCase {}

class MockAddAppointmentServiceUseCase extends Mock
    implements AddAppointmentServiceUseCase {}

void main() {
  late MockGetFinancialSnapshotUseCase mockGetSnapshot;
  late MockAddPaymentsUseCase mockAddPayments;
  late MockAddRefundUseCase mockAddRefund;
  late MockAddDiscountUseCase mockAddDiscount;
  late MockAddAppointmentServiceUseCase mockAddService;
  late ReceptionPaymentCubit cubit;

  const tSnapshot = FinancialSnapshotEntity(
    appointmentId: 10,
    appointmentNumber: 'APT-100',
    patientName: 'أحمد محمود',
    doctorName: 'د. سامي',
    currency: FinancialCurrencyEntity(code: 'EGP', symbol: 'ج.م', decimals: 2),
    summary: FinancialSummaryEntity(
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
    capabilities: FinancialCapabilitiesEntity(
      canPay: true,
      canDiscount: true,
      canAddService: true,
    ),
    charges: [],
    transactions: [],
    paymentMethods: [],
    bankAccounts: [],
  );

  setUp(() {
    mockGetSnapshot = MockGetFinancialSnapshotUseCase();
    mockAddPayments = MockAddPaymentsUseCase();
    mockAddRefund = MockAddRefundUseCase();
    mockAddDiscount = MockAddDiscountUseCase();
    mockAddService = MockAddAppointmentServiceUseCase();

    cubit = ReceptionPaymentCubit(
      appointmentId: 10,
      getSnapshotUseCase: mockGetSnapshot,
      addPaymentsUseCase: mockAddPayments,
      addRefundUseCase: mockAddRefund,
      addDiscountUseCase: mockAddDiscount,
      addServiceUseCase: mockAddService,
    );
  });

  tearDown(() => cubit.close());

  test('initial state has correct defaults', () {
    expect(cubit.state.status, ReceptionPaymentStatus.initial);
    expect(cubit.state.snapshot, isNull);
    expect(cubit.state.activeTab, 0);
  });

  blocTest<ReceptionPaymentCubit, ReceptionPaymentState>(
    'loadSnapshot emits [loading, success] with snapshot',
    build: () {
      when(() => mockGetSnapshot(10))
          .thenAnswer((_) async => const Right(tSnapshot));
      return cubit;
    },
    act: (cubit) => cubit.loadSnapshot(),
    expect: () => [
      const ReceptionPaymentState(status: ReceptionPaymentStatus.loading),
      isA<ReceptionPaymentState>()
          .having((s) => s.status, 'status', ReceptionPaymentStatus.success)
          .having((s) => s.snapshot, 'snapshot', tSnapshot),
    ],
  );

  blocTest<ReceptionPaymentCubit, ReceptionPaymentState>(
    'loadSnapshot emits [loading, error] on failure',
    build: () {
      when(() => mockGetSnapshot(10))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));
      return cubit;
    },
    act: (cubit) => cubit.loadSnapshot(),
    expect: () => [
      const ReceptionPaymentState(status: ReceptionPaymentStatus.loading),
      isA<ReceptionPaymentState>()
          .having((s) => s.status, 'status', ReceptionPaymentStatus.error)
          .having((s) => s.errorMessage, 'errorMessage', 'Error'),
    ],
  );

  blocTest<ReceptionPaymentCubit, ReceptionPaymentState>(
    'submitPayments emits [submitting, success] on valid payment',
    build: () {
      when(() => mockAddPayments(
            appointmentId: any(named: 'appointmentId'),
            expectedFinancialVersion: any(named: 'expectedFinancialVersion'),
            payments: any(named: 'payments'),
            clientRequestId: any(named: 'clientRequestId'),
          )).thenAnswer((_) async => const Right(PaymentActionResultEntity(
            success: true,
            message: 'Payment recorded',
            snapshot: tSnapshot,
          )));
      return cubit;
    },
    seed: () => const ReceptionPaymentState(
      status: ReceptionPaymentStatus.success,
      snapshot: tSnapshot,
    ),
    act: (cubit) {
      cubit.addSplitRow();
      cubit.updateSplitRow(
        cubit.state.splitPayments.first.copyWith(amount: '200.00'),
      );
      return cubit.submitPayments();
    },
    expect: () => [
      isA<ReceptionPaymentState>(), // addSplitRow
      isA<ReceptionPaymentState>(), // updateSplitRow
      isA<ReceptionPaymentState>() // submitting
          .having((s) => s.status, 'status', ReceptionPaymentStatus.submitting),
      isA<ReceptionPaymentState>() // success
          .having((s) => s.status, 'status', ReceptionPaymentStatus.success)
          .having((s) => s.actionSuccessMessage, 'msg', 'Payment recorded'),
    ],
  );

  test('switchTab updates activeTab index', () {
    cubit.switchTab(2);
    expect(cubit.state.activeTab, 2);
  });
}
