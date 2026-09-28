import '../../domain/entities/financial_capabilities_entity.dart';

class FinancialCapabilitiesModel extends FinancialCapabilitiesEntity {
  const FinancialCapabilitiesModel({
    super.canPay,
    super.canRefund,
    super.canDiscount,
    super.canAddService,
    super.canViewReceipt,
  });

  factory FinancialCapabilitiesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const FinancialCapabilitiesModel();
    }

    return FinancialCapabilitiesModel(
      canPay: json['can_pay'] as bool? ?? false,
      canRefund: json['can_refund'] as bool? ?? false,
      canDiscount: json['can_discount'] as bool? ?? false,
      canAddService: json['can_add_service'] as bool? ?? false,
      canViewReceipt: json['can_view_receipt'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'can_pay': canPay,
      'can_refund': canRefund,
      'can_discount': canDiscount,
      'can_add_service': canAddService,
      'can_view_receipt': canViewReceipt,
    };
  }
}
