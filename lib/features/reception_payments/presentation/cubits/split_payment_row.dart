import 'package:equatable/equatable.dart';

class SplitPaymentRow extends Equatable {
  final String id;
  final String paymentMethod;
  final String amount;
  final int? bankAccountId;
  final String referenceNumber;
  final String description;

  const SplitPaymentRow({
    required this.id,
    required this.paymentMethod,
    this.amount = '',
    this.bankAccountId,
    this.referenceNumber = '',
    this.description = '',
  });

  SplitPaymentRow copyWith({
    String? id,
    String? paymentMethod,
    String? amount,
    int? bankAccountId,
    String? referenceNumber,
    String? description,
  }) {
    return SplitPaymentRow(
      id: id ?? this.id,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      bankAccountId: bankAccountId ?? this.bankAccountId,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toRequestMap() {
    return {
      'payment_method': paymentMethod,
      'amount': amount,
      if (bankAccountId != null) 'bank_account_id': bankAccountId,
      if (referenceNumber.isNotEmpty) 'reference_number': referenceNumber,
      if (description.isNotEmpty) 'description': description,
    };
  }

  @override
  List<Object?> get props => [
        id,
        paymentMethod,
        amount,
        bankAccountId,
        referenceNumber,
        description,
      ];
}
