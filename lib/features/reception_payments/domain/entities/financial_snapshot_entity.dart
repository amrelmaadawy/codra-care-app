import 'package:equatable/equatable.dart';
import 'appointment_charge_item_entity.dart';
import 'bank_account_entity.dart';
import 'financial_capabilities_entity.dart';
import 'financial_currency_entity.dart';
import 'financial_summary_entity.dart';
import 'payment_method_entity.dart';
import 'payment_transaction_entity.dart';

class FinancialSnapshotEntity extends Equatable {
  final int appointmentId;
  final String? appointmentNumber;
  final String? patientName;
  final String? doctorName;
  final FinancialCurrencyEntity currency;
  final FinancialSummaryEntity summary;
  final FinancialCapabilitiesEntity capabilities;
  final List<AppointmentChargeItemEntity> charges;
  final List<PaymentTransactionEntity> transactions;
  final List<PaymentMethodEntity> paymentMethods;
  final List<BankAccountEntity> bankAccounts;

  const FinancialSnapshotEntity({
    required this.appointmentId,
    this.appointmentNumber,
    this.patientName,
    this.doctorName,
    required this.currency,
    required this.summary,
    required this.capabilities,
    required this.charges,
    required this.transactions,
    required this.paymentMethods,
    required this.bankAccounts,
  });

  @override
  List<Object?> get props => [
        appointmentId,
        appointmentNumber,
        patientName,
        doctorName,
        currency,
        summary,
        capabilities,
        charges,
        transactions,
        paymentMethods,
        bankAccounts,
      ];
}
