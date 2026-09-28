import '../../domain/entities/payment_action_result_entity.dart';
import 'financial_snapshot_model.dart';

class PaymentActionResultModel extends PaymentActionResultEntity {
  const PaymentActionResultModel({
    required super.success,
    required super.message,
    super.snapshot,
    super.voucherId,
    super.voucherNumber,
  });

  factory PaymentActionResultModel.fromJson(Map<String, dynamic> json) {
    final success = json['success'] as bool? ?? false;
    final message = json['message'] as String? ?? '';
    final data = json['data'] as Map<String, dynamic>?;

    FinancialSnapshotModel? snapshot;
    int? voucherId;
    String? voucherNumber;

    if (data != null) {
      if (data.containsKey('snapshot') &&
          data['snapshot'] is Map<String, dynamic>) {
        snapshot = FinancialSnapshotModel.fromJson(
          data['snapshot'] as Map<String, dynamic>,
        );
      } else if (data.containsKey('summary')) {
        snapshot = FinancialSnapshotModel.fromJson(data);
      }

      voucherId = (data['voucher_id'] as num?)?.toInt() ??
          (data['voucher']?['id'] as num?)?.toInt();
      voucherNumber = data['voucher_number'] as String? ??
          data['voucher']?['number'] as String?;
    }

    return PaymentActionResultModel(
      success: success,
      message: message,
      snapshot: snapshot,
      voucherId: voucherId,
      voucherNumber: voucherNumber,
    );
  }
}
