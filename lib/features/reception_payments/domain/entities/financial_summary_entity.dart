import 'package:equatable/equatable.dart';

class FinancialSummaryEntity extends Equatable {
  final String grossCharges;
  final String discountTotal;
  final String netDue;
  final String payments;
  final String refunds;
  final String balance;
  final String maxPayable;
  final String maxRefundable;
  final String maxDiscount;
  final String financialStatus;
  final int financialVersion;

  const FinancialSummaryEntity({
    required this.grossCharges,
    required this.discountTotal,
    required this.netDue,
    required this.payments,
    required this.refunds,
    required this.balance,
    required this.maxPayable,
    required this.maxRefundable,
    required this.maxDiscount,
    required this.financialStatus,
    required this.financialVersion,
  });

  bool get isPaid => financialStatus == 'paid';
  bool get isPartiallyPaid => financialStatus == 'partially_paid';
  bool get isUnpaid => financialStatus == 'unpaid';
  bool get isOverpaid => financialStatus == 'overpaid';

  @override
  List<Object?> get props => [
        grossCharges,
        discountTotal,
        netDue,
        payments,
        refunds,
        balance,
        maxPayable,
        maxRefundable,
        maxDiscount,
        financialStatus,
        financialVersion,
      ];
}
