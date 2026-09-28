import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/financial_snapshot_entity.dart';
import '../cubits/reception_payment_cubit.dart';
import '../cubits/reception_payment_state.dart';
import 'charge_items_list.dart';
import 'financial_summary_card.dart';
import 'reception_payment_dialogs.dart';
import 'split_payment_editor.dart';
import 'transactions_history_list.dart';

class ReceptionPaymentSheetContent extends StatelessWidget {
  final FinancialSnapshotEntity snapshot;
  final ReceptionPaymentState state;

  const ReceptionPaymentSheetContent({
    super.key,
    required this.snapshot,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceptionPaymentCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FinancialSummaryCard(
          summary: snapshot.summary,
          currency: snapshot.currency,
        ),
        const SizedBox(height: AppSpacing.sm),
        DefaultTabController(
          length: 3,
          initialIndex: state.activeTab,
          child: Column(
            children: [
              Container(
                height: 42,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: context.surfaceVariantColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  onTap: cubit.switchTab,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  labelColor: context.primaryColor,
                  unselectedLabelColor: context.textSecondaryColor,
                  labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  tabs: [
                    Tab(text: 'payments.tab_collect'.tr()),
                    Tab(text: 'payments.tab_services'.tr()),
                    Tab(text: 'payments.tab_history'.tr()),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (state.activeTab == 0)
                _buildCollectTab(context, cubit)
              else if (state.activeTab == 1)
                ChargeItemsList(
                  charges: snapshot.charges,
                  currency: snapshot.currency,
                  canAddService: snapshot.capabilities.canAddService,
                  onAddServicePressed: () =>
                      ReceptionPaymentDialogs.showAddService(
                    context,
                    snapshot.appointmentId,
                  ),
                )
              else
                TransactionsHistoryList(
                  transactions: snapshot.transactions,
                  currency: snapshot.currency,
                  onRefundPressed: (tx) => ReceptionPaymentDialogs.showRefund(
                    context,
                    tx,
                    snapshot.currency.symbol,
                  ),
                  onViewVoucherPressed: (vId) =>
                      ReceptionPaymentDialogs.showVoucherPreview(
                    context,
                    snapshot.appointmentId,
                    vId,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCollectTab(BuildContext context, ReceptionPaymentCubit cubit) {
    final canSubmit = snapshot.capabilities.canPay && !state.isSubmitting;

    return Column(
      children: [
        if (snapshot.capabilities.canDiscount) ...[
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: () => ReceptionPaymentDialogs.showAddDiscount(
                context,
                snapshot.summary.maxDiscount,
                snapshot.currency.symbol,
              ),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_offer_outlined, size: 14, color: AppColors.accent),
                    const SizedBox(width: 5),
                    Text(
                      'payments.add_discount_button'.tr(),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.accent),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        SplitPaymentEditor(
          rows: state.splitPayments,
          paymentMethods: snapshot.paymentMethods,
          bankAccounts: snapshot.bankAccounts,
          onRowUpdated: cubit.updateSplitRow,
          onRowRemoved: cubit.removeSplitRow,
          onAddRow: cubit.addSplitRow,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          labelKey: 'payments.submit_payment',
          isLoading: state.isSubmitting,
          onPressed: canSubmit ? cubit.submitPayments : null,
        ),
      ],
    );
  }
}
