import '../../domain/entities/financial_snapshot_entity.dart';
import 'appointment_charge_item_model.dart';
import 'bank_account_model.dart';
import 'financial_capabilities_model.dart';
import 'financial_currency_model.dart';
import 'financial_summary_model.dart';
import 'payment_method_model.dart';
import 'payment_transaction_model.dart';

class FinancialSnapshotModel extends FinancialSnapshotEntity {
  const FinancialSnapshotModel({
    required super.appointmentId,
    super.appointmentNumber,
    super.patientName,
    super.doctorName,
    required super.currency,
    required super.summary,
    required super.capabilities,
    required super.charges,
    required super.transactions,
    required super.paymentMethods,
    required super.bankAccounts,
  });

  factory FinancialSnapshotModel.fromJson(Map<String, dynamic> json) {
    final aptJson = json['appointment'] as Map<String, dynamic>?;
    final patientJson = aptJson?['patient'] as Map<String, dynamic>?;
    final doctorJson = aptJson?['doctor'] as Map<String, dynamic>?;

    final appointmentId = (aptJson?['id'] ?? json['appointment_id'] as num?)?.toInt() ?? 0;
    final appointmentNumber = aptJson?['number'] as String? ?? json['appointment_number'] as String?;
    final patientName = patientJson?['name'] as String? ?? json['patient_name'] as String?;
    final doctorName = doctorJson?['name'] as String? ?? json['doctor_name'] as String?;

    final currencyJson = (json['currency'] ?? json['money']) as Map<String, dynamic>?;
    final summaryJson = json['summary'] as Map<String, dynamic>? ?? {};
    final capabilitiesJson =
        json['capabilities'] as Map<String, dynamic>? ?? {};

    final chargesRaw = json['charges'] as List<dynamic>? ?? [];
    final transactionsRaw = json['transactions'] as List<dynamic>? ?? [];
    final methodsRaw = json['payment_methods'] as List<dynamic>? ?? [];
    final bankAccountsRaw = json['bank_accounts'] as List<dynamic>? ?? [];

    return FinancialSnapshotModel(
      appointmentId: appointmentId,
      appointmentNumber: appointmentNumber,
      patientName: patientName,
      doctorName: doctorName,
      currency: FinancialCurrencyModel.fromJson(currencyJson),
      summary: FinancialSummaryModel.fromJson(summaryJson),
      capabilities: FinancialCapabilitiesModel.fromJson(capabilitiesJson),
      charges: chargesRaw
          .whereType<Map<String, dynamic>>()
          .map(AppointmentChargeItemModel.fromJson)
          .toList(),
      transactions: transactionsRaw
          .whereType<Map<String, dynamic>>()
          .map(PaymentTransactionModel.fromJson)
          .toList(),
      paymentMethods: methodsRaw
          .whereType<Map<String, dynamic>>()
          .map(PaymentMethodModel.fromJson)
          .toList(),
      bankAccounts: bankAccountsRaw
          .whereType<Map<String, dynamic>>()
          .map(BankAccountModel.fromJson)
          .toList(),
    );
  }
}
