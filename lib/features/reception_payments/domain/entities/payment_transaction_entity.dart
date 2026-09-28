import 'package:equatable/equatable.dart';

class PaymentTransactionEntity extends Equatable {
  final int id;
  final String? transactionNumber;
  final String type;
  final String amount;
  final String? paymentMethod;
  final String? paymentMethodLabel;
  final int? bankAccountId;
  final String? referenceNumber;
  final String? description;
  final String? notes;
  final int? voucherId;
  final String? voucherNumber;
  final bool canRefund;
  final String? maxRefundable;
  final String? createdAt;
  final String? creatorName;

  const PaymentTransactionEntity({
    required this.id,
    this.transactionNumber,
    required this.type,
    required this.amount,
    this.paymentMethod,
    this.paymentMethodLabel,
    this.bankAccountId,
    this.referenceNumber,
    this.description,
    this.notes,
    this.voucherId,
    this.voucherNumber,
    this.canRefund = false,
    this.maxRefundable,
    this.createdAt,
    this.creatorName,
  });

  bool get isPayment => type == 'payment';
  bool get isRefund => type == 'refund';
  bool get isDiscount => type == 'discount';

  @override
  List<Object?> get props => [
        id,
        transactionNumber,
        type,
        amount,
        paymentMethod,
        paymentMethodLabel,
        bankAccountId,
        referenceNumber,
        description,
        notes,
        voucherId,
        voucherNumber,
        canRefund,
        maxRefundable,
        createdAt,
        creatorName,
      ];
}
