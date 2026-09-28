import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/payment_action_result_entity.dart';
import '../../domain/use_cases/add_appointment_service_use_case.dart';
import '../../domain/use_cases/add_discount_use_case.dart';
import '../../domain/use_cases/add_payments_use_case.dart';
import '../../domain/use_cases/add_refund_use_case.dart';
import '../../domain/use_cases/get_financial_snapshot_use_case.dart';
import 'reception_payment_state.dart';
import 'split_payment_row.dart';

class ReceptionPaymentCubit extends Cubit<ReceptionPaymentState> {
  final int appointmentId;
  final GetFinancialSnapshotUseCase getSnapshotUseCase;
  final AddPaymentsUseCase addPaymentsUseCase;
  final AddRefundUseCase addRefundUseCase;
  final AddDiscountUseCase addDiscountUseCase;
  final AddAppointmentServiceUseCase addServiceUseCase;
  static const _uuid = Uuid();

  ReceptionPaymentCubit({
    required this.appointmentId,
    required this.getSnapshotUseCase,
    required this.addPaymentsUseCase,
    required this.addRefundUseCase,
    required this.addDiscountUseCase,
    required this.addServiceUseCase,
  }) : super(const ReceptionPaymentState());

  Future<void> loadSnapshot() async {
    emit(state.copyWith(status: ReceptionPaymentStatus.loading));
    final result = await getSnapshotUseCase(appointmentId);
    result.fold(
      (f) => emit(state.copyWith(status: ReceptionPaymentStatus.error, errorMessage: f.message)),
      (snapshot) {
        final initialRows = state.splitPayments.isEmpty
            ? [
                SplitPaymentRow(
                  id: _uuid.v4(),
                  paymentMethod: snapshot.paymentMethods.isNotEmpty
                      ? snapshot.paymentMethods.first.code
                      : 'cash',
                  amount: snapshot.summary.maxPayable,
                )
              ]
            : state.splitPayments;
        emit(state.copyWith(
          status: ReceptionPaymentStatus.success,
          snapshot: snapshot,
          splitPayments: initialRows,
        ));
      },
    );
  }

  void switchTab(int index) => emit(state.copyWith(activeTab: index));

  void addSplitRow() {
    final method = state.snapshot?.paymentMethods.isNotEmpty == true
        ? state.snapshot!.paymentMethods.first.code
        : 'cash';
    emit(state.copyWith(splitPayments: [
      ...state.splitPayments,
      SplitPaymentRow(id: _uuid.v4(), paymentMethod: method),
    ]));
  }

  void removeSplitRow(String id) {
    if (state.splitPayments.length <= 1) return;
    emit(state.copyWith(
      splitPayments: state.splitPayments.where((r) => r.id != id).toList(),
    ));
  }

  void updateSplitRow(SplitPaymentRow row) {
    emit(state.copyWith(
      splitPayments: state.splitPayments.map((r) => r.id == row.id ? row : r).toList(),
    ));
  }

  Future<void> submitPayments() async {
    final snapshot = state.snapshot;
    if (snapshot == null) return;
    final validPayments = state.splitPayments
        .where((p) => p.amount.trim().isNotEmpty)
        .map((p) => p.toRequestMap())
        .toList();
    if (validPayments.isEmpty) {
      emit(state.copyWith(errorMessage: 'payments.error_enter_amount'));
      return;
    }
    emit(state.copyWith(status: ReceptionPaymentStatus.submitting));
    final result = await addPaymentsUseCase(
      appointmentId: appointmentId,
      expectedFinancialVersion: snapshot.summary.financialVersion,
      payments: validPayments,
      clientRequestId: _uuid.v4(),
    );
    result.fold(_handleFailure, (res) => _handleSuccess(res, resetPayments: true));
  }

  Future<void> submitRefund({
    required String amount,
    String? reason,
    int? specificPaymentTransactionId,
  }) async {
    final snapshot = state.snapshot;
    if (snapshot == null) return;
    emit(state.copyWith(status: ReceptionPaymentStatus.submitting));
    final result = await addRefundUseCase(
      appointmentId: appointmentId,
      expectedFinancialVersion: snapshot.summary.financialVersion,
      amount: amount,
      reason: reason,
      specificPaymentTransactionId: specificPaymentTransactionId,
      clientRequestId: _uuid.v4(),
    );
    result.fold(_handleFailure, _handleSuccess);
  }

  Future<void> submitDiscount({required String amount, required String reason}) async {
    final snapshot = state.snapshot;
    if (snapshot == null) return;
    emit(state.copyWith(status: ReceptionPaymentStatus.submitting));
    final result = await addDiscountUseCase(
      appointmentId: appointmentId,
      expectedFinancialVersion: snapshot.summary.financialVersion,
      amount: amount,
      reason: reason,
      clientRequestId: _uuid.v4(),
    );
    result.fold(_handleFailure, _handleSuccess);
  }

  Future<void> submitAddService({required int serviceId, int? quantity}) async {
    final snapshot = state.snapshot;
    if (snapshot == null) return;
    emit(state.copyWith(status: ReceptionPaymentStatus.submitting));
    final result = await addServiceUseCase(
      appointmentId: appointmentId,
      expectedFinancialVersion: snapshot.summary.financialVersion,
      serviceId: serviceId,
      quantity: quantity,
      clientRequestId: _uuid.v4(),
    );
    result.fold(_handleFailure, _handleSuccess);
  }

  void _handleSuccess(PaymentActionResultEntity res, {bool resetPayments = false}) {
    final snap = res.snapshot ?? state.snapshot;
    emit(state.copyWith(
      status: ReceptionPaymentStatus.success,
      snapshot: snap,
      actionSuccessMessage: res.message,
      lastVoucherId: res.voucherId,
      splitPayments: resetPayments && snap != null
          ? [
              SplitPaymentRow(
                id: _uuid.v4(),
                paymentMethod: snap.paymentMethods.isNotEmpty
                    ? snap.paymentMethods.first.code
                    : 'cash',
                amount: snap.summary.maxPayable,
              )
            ]
          : null,
    ));
  }

  void _handleFailure(Failure failure) {
    if (failure.statusCode == 409) {
      emit(state.copyWith(
        status: ReceptionPaymentStatus.conflict,
        errorMessage: failure.message,
      ));
      loadSnapshot();
    } else {
      emit(state.copyWith(
        status: ReceptionPaymentStatus.error,
        errorMessage: failure.message,
      ));
    }
  }

  void clearActionMessage() => emit(state.copyWith(clearActionSuccess: true));
}
