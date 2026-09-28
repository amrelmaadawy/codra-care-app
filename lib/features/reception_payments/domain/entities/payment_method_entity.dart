import 'package:equatable/equatable.dart';

class PaymentMethodEntity extends Equatable {
  final String code;
  final String name;
  final String type;
  final String? icon;
  final int? defaultBankAccountId;
  final bool requiresReference;
  final bool requiresBankAccount;

  const PaymentMethodEntity({
    required this.code,
    required this.name,
    this.type = 'cash',
    this.icon,
    this.defaultBankAccountId,
    this.requiresReference = false,
    this.requiresBankAccount = false,
  });

  @override
  List<Object?> get props => [
        code,
        name,
        type,
        icon,
        defaultBankAccountId,
        requiresReference,
        requiresBankAccount,
      ];
}
