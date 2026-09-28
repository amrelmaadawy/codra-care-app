import '../../domain/entities/financial_currency_entity.dart';

class FinancialCurrencyModel extends FinancialCurrencyEntity {
  const FinancialCurrencyModel({
    required super.code,
    required super.symbol,
    required super.decimals,
  });

  factory FinancialCurrencyModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const FinancialCurrencyModel(
        code: 'EGP',
        symbol: 'ج.م',
        decimals: 2,
      );
    }

    return FinancialCurrencyModel(
      code: json['code'] as String? ?? json['currency_code'] as String? ?? 'EGP',
      symbol: json['symbol'] as String? ?? json['currency_symbol'] as String? ?? 'ج.م',
      decimals: (json['decimals'] ?? json['decimal_digits'] as num?)?.toInt() ?? 2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'symbol': symbol,
      'decimals': decimals,
    };
  }
}
