import 'package:equatable/equatable.dart';

class BankAccountEntity extends Equatable {
  final int id;
  final String bankName;
  final String accountNumber;
  final String? accountName;

  const BankAccountEntity({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    this.accountName,
  });

  String get displayName {
    if (accountName != null && accountName!.isNotEmpty) {
      return '$bankName - $accountName ($accountNumber)';
    }
    return '$bankName ($accountNumber)';
  }

  @override
  List<Object?> get props => [id, bankName, accountNumber, accountName];
}
