import 'package:equatable/equatable.dart';
import 'financial_snapshot_entity.dart';

class PaymentActionResultEntity extends Equatable {
  final bool success;
  final String message;
  final FinancialSnapshotEntity? snapshot;
  final int? voucherId;
  final String? voucherNumber;

  const PaymentActionResultEntity({
    required this.success,
    required this.message,
    this.snapshot,
    this.voucherId,
    this.voucherNumber,
  });

  @override
  List<Object?> get props => [
        success,
        message,
        snapshot,
        voucherId,
        voucherNumber,
      ];
}
