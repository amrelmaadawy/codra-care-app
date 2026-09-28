import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/app_di.dart';
import '../../domain/entities/payment_transaction_entity.dart';
import '../cubits/reception_payment_cubit.dart';
import '../cubits/service_options_cubit.dart';
import 'add_discount_modal.dart';
import 'add_service_modal.dart';
import 'refund_modal.dart';
import 'voucher_preview_modal.dart';

abstract final class ReceptionPaymentDialogs {
  static void showAddService(BuildContext context, int appointmentId) {
    final cubit = context.read<ReceptionPaymentCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider(
        create: (_) => ServiceOptionsCubit(
          getServiceOptionsUseCase: getIt(),
          appointmentId: appointmentId,
        ),
        child: AddServiceModal(
          onConfirm: (serviceId, quantity) {
            cubit.submitAddService(
              serviceId: serviceId,
              quantity: quantity,
            );
          },
        ),
      ),
    );
  }

  static void showAddDiscount(
    BuildContext context,
    String maxDiscount,
    String currencySymbol,
  ) {
    final cubit = context.read<ReceptionPaymentCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddDiscountModal(
        maxDiscount: maxDiscount,
        currencySymbol: currencySymbol,
        onConfirm: (amount, reason) {
          cubit.submitDiscount(amount: amount, reason: reason);
        },
      ),
    );
  }

  static void showRefund(
    BuildContext context,
    PaymentTransactionEntity tx,
    String currencySymbol,
  ) {
    final cubit = context.read<ReceptionPaymentCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => RefundModal(
        transaction: tx,
        currencySymbol: currencySymbol,
        onConfirm: (amount, reason, txId) {
          cubit.submitRefund(
            amount: amount,
            reason: reason,
            specificPaymentTransactionId: txId,
          );
        },
      ),
    );
  }

  static void showVoucherPreview(
    BuildContext context,
    int appointmentId,
    int voucherId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => VoucherPreviewModal(
        appointmentId: appointmentId,
        voucherId: voucherId,
      ),
    );
  }
}
