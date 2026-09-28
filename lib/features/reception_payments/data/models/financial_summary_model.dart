import '../../domain/entities/financial_summary_entity.dart';

class FinancialSummaryModel extends FinancialSummaryEntity {
  const FinancialSummaryModel({
    required super.grossCharges,
    required super.discountTotal,
    required super.netDue,
    required super.payments,
    required super.refunds,
    required super.balance,
    required super.maxPayable,
    required super.maxRefundable,
    required super.maxDiscount,
    required super.financialStatus,
    required super.financialVersion,
  });

  factory FinancialSummaryModel.fromJson(Map<String, dynamic> json) {
    return FinancialSummaryModel(
      grossCharges: json['gross_charges']?.toString() ?? '0.00',
      discountTotal: json['discount_total']?.toString() ?? '0.00',
      netDue: json['net_due']?.toString() ?? '0.00',
      payments: json['payments']?.toString() ?? '0.00',
      refunds: json['refunds']?.toString() ?? '0.00',
      balance: json['balance']?.toString() ?? '0.00',
      maxPayable: json['max_payable']?.toString() ?? '0.00',
      maxRefundable: json['max_refundable']?.toString() ?? '0.00',
      maxDiscount: json['max_discount']?.toString() ?? '0.00',
      financialStatus: json['financial_status']?.toString() ?? 'unpaid',
      financialVersion: (json['financial_version'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gross_charges': grossCharges,
      'discount_total': discountTotal,
      'net_due': netDue,
      'payments': payments,
      'refunds': refunds,
      'balance': balance,
      'max_payable': maxPayable,
      'max_refundable': maxRefundable,
      'max_discount': maxDiscount,
      'financial_status': financialStatus,
      'financial_version': financialVersion,
    };
  }
}
