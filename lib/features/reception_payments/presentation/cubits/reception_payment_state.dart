import 'package:equatable/equatable.dart';
import '../../domain/entities/financial_snapshot_entity.dart';
import 'split_payment_row.dart';

enum ReceptionPaymentStatus {
  initial,
  loading,
  success,
  submitting,
  conflict,
  error,
}

class ReceptionPaymentState extends Equatable {
  final ReceptionPaymentStatus status;
  final FinancialSnapshotEntity? snapshot;
  final int activeTab;
  final List<SplitPaymentRow> splitPayments;
  final String? errorMessage;
  final String? actionSuccessMessage;
  final int? lastVoucherId;

  const ReceptionPaymentState({
    this.status = ReceptionPaymentStatus.initial,
    this.snapshot,
    this.activeTab = 0,
    this.splitPayments = const [],
    this.errorMessage,
    this.actionSuccessMessage,
    this.lastVoucherId,
  });

  bool get isLoading => status == ReceptionPaymentStatus.loading;
  bool get isSubmitting => status == ReceptionPaymentStatus.submitting;
  bool get hasConflict => status == ReceptionPaymentStatus.conflict;

  ReceptionPaymentState copyWith({
    ReceptionPaymentStatus? status,
    FinancialSnapshotEntity? snapshot,
    int? activeTab,
    List<SplitPaymentRow>? splitPayments,
    String? errorMessage,
    String? actionSuccessMessage,
    int? lastVoucherId,
    bool clearActionSuccess = false,
  }) {
    return ReceptionPaymentState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      activeTab: activeTab ?? this.activeTab,
      splitPayments: splitPayments ?? this.splitPayments,
      errorMessage: errorMessage,
      actionSuccessMessage: clearActionSuccess
          ? null
          : (actionSuccessMessage ?? this.actionSuccessMessage),
      lastVoucherId: lastVoucherId ?? this.lastVoucherId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        snapshot,
        activeTab,
        splitPayments,
        errorMessage,
        actionSuccessMessage,
        lastVoucherId,
      ];
}
