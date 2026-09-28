import 'package:equatable/equatable.dart';

class FinancialCurrencyEntity extends Equatable {
  final String code;
  final String symbol;
  final int decimals;

  const FinancialCurrencyEntity({
    required this.code,
    required this.symbol,
    required this.decimals,
  });

  const FinancialCurrencyEntity.fallback()
      : code = 'EGP',
        symbol = 'ج.م',
        decimals = 2;

  String format(String amount) {
    return '$amount $symbol';
  }

  @override
  List<Object?> get props => [code, symbol, decimals];
}
