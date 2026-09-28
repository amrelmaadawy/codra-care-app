import '../../domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.code,
    required super.name,
    super.type,
    super.icon,
    super.defaultBankAccountId,
    super.requiresReference,
    super.requiresBankAccount,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      code: json['code'] as String? ?? 'cash',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'cash',
      icon: json['icon'] as String?,
      defaultBankAccountId: (json['default_bank_account_id'] as num?)?.toInt(),
      requiresReference: json['requires_reference'] as bool? ?? false,
      requiresBankAccount: json['requires_bank_account'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'type': type,
      'icon': icon,
      'default_bank_account_id': defaultBankAccountId,
      'requires_reference': requiresReference,
      'requires_bank_account': requiresBankAccount,
    };
  }
}
