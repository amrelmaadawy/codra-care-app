import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubits/reception_payment_cubit.dart';
import '../cubits/reception_payment_state.dart';
import 'reception_payment_sheet_content.dart';
import 'reception_payment_sheet_header.dart';
import 'reception_payment_shimmer.dart';

class ReceptionPaymentBottomSheet extends StatelessWidget {
  const ReceptionPaymentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return BlocConsumer<ReceptionPaymentCubit, ReceptionPaymentState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!.tr());
        }
        if (state.actionSuccessMessage != null) {
          AppSnackBar.showSuccess(context, state.actionSuccessMessage!);
          context.read<ReceptionPaymentCubit>().clearActionMessage();
        }
      },
      builder: (context, state) {
        final content = _buildContent(context, state);

        if (isTablet) {
          return Dialog(
            backgroundColor: context.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620, maxHeight: 750),
              child: content,
            ),
          );
        }

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.90,
          ),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: content,
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ReceptionPaymentState state) {
    if (state.isLoading) {
      return const ReceptionPaymentShimmer();
    }

    final snapshot = state.snapshot;
    if (snapshot == null) {
      return _buildErrorState(context);
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReceptionPaymentSheetHeader(
            patient: snapshot.patientName,
            aptNumber: snapshot.appointmentNumber,
            onClose: () => Navigator.of(context).maybePop(),
          ),
          if (state.hasConflict) ...[
            const SizedBox(height: AppSpacing.xs),
            _buildConflictBanner(context),
          ],
          const SizedBox(height: AppSpacing.sm),
          ReceptionPaymentSheetContent(
            snapshot: snapshot,
            state: state,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildConflictBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.sync_problem, color: AppColors.warning, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'payments.conflict_refreshed'.tr(),
              style: const TextStyle(color: AppColors.warning, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(child: ReceptionPaymentDragHandle()),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long_outlined, size: 40, color: AppColors.error),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'payments.error_load'.tr(),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: () => context.read<ReceptionPaymentCubit>().loadSnapshot(),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text('reception_queue.retry'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
