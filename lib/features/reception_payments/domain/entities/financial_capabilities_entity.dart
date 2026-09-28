import 'package:equatable/equatable.dart';

class FinancialCapabilitiesEntity extends Equatable {
  final bool canPay;
  final bool canRefund;
  final bool canDiscount;
  final bool canAddService;
  final bool canViewReceipt;

  const FinancialCapabilitiesEntity({
    this.canPay = false,
    this.canRefund = false,
    this.canDiscount = false,
    this.canAddService = false,
    this.canViewReceipt = false,
  });

  @override
  List<Object?> get props => [
        canPay,
        canRefund,
        canDiscount,
        canAddService,
        canViewReceipt,
      ];
}
