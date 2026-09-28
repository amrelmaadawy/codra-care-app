import '../../domain/entities/payment_transaction_entity.dart';

class PaymentTransactionModel extends PaymentTransactionEntity {
  const PaymentTransactionModel({
    required super.id,
    super.transactionNumber,
    required super.type,
    required super.amount,
    super.paymentMethod,
    super.paymentMethodLabel,
    super.bankAccountId,
    super.referenceNumber,
    super.description,
    super.notes,
    super.voucherId,
    super.voucherNumber,
    super.canRefund,
    super.maxRefundable,
    super.createdAt,
    super.creatorName,
  });

  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) {
    return PaymentTransactionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      transactionNumber: json['transaction_number'] as String?,
      type: json['type'] as String? ?? 'payment',
      amount: json['amount']?.toString() ?? '0.00',
      paymentMethod: json['payment_method'] as String?,
      paymentMethodLabel: json['payment_method_label'] as String?,
      bankAccountId: (json['bank_account_id'] as num?)?.toInt(),
      referenceNumber: json['reference_number'] as String?,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      voucherId: (json['voucher_id'] as num?)?.toInt(),
      voucherNumber: json['voucher_number'] as String?,
      canRefund: json['can_refund'] as bool? ?? false,
      maxRefundable: json['max_refundable']?.toString(),
      createdAt: json['created_at'] as String?,
      creatorName: json['creator_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_number': transactionNumber,
      'type': type,
      'amount': amount,
      'payment_method': paymentMethod,
      'payment_method_label': paymentMethodLabel,
      'bank_account_id': bankAccountId,
      'reference_number': referenceNumber,
      'description': description,
      'notes': notes,
      'voucher_id': voucherId,
      'voucher_number': voucherNumber,
      'can_refund': canRefund,
      'max_refundable': maxRefundable,
      'created_at': createdAt,
      'creator_name': creatorName,
    };
  }
}
