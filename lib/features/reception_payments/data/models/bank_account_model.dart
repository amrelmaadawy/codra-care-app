import '../../domain/entities/bank_account_entity.dart';

class BankAccountModel extends BankAccountEntity {
  const BankAccountModel({
    required super.id,
    required super.bankName,
    required super.accountNumber,
    super.accountName,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      bankName: json['bank_name'] as String? ?? '',
      accountNumber: json['account_number']?.toString() ?? '',
      accountName: json['account_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bank_name': bankName,
      'account_number': accountNumber,
      'account_name': accountName,
    };
  }
}
