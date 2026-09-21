import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../cubit/prescription_detail_cubit.dart';
import '../cubit/prescription_detail_state.dart';
import '../widgets/prescription_detail_app_bar.dart';
import '../widgets/prescription_item_tile.dart';
import '../widgets/prescription_shimmer.dart';

class PrescriptionDetailScreen extends StatefulWidget {
  final int prescriptionId;

  const PrescriptionDetailScreen({super.key, required this.prescriptionId});

  @override
  State<PrescriptionDetailScreen> createState() => _PrescriptionDetailScreenState();
}

class _PrescriptionDetailScreenState extends State<PrescriptionDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PrescriptionDetailCubit>().loadPrescription(widget.prescriptionId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionDetailCubit, PrescriptionDetailState>(
      builder: (context, state) {
        final rx = state is PrescriptionDetailLoaded ? state.prescription : null;

        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: PrescriptionDetailAppBar(
            prescription: rx,
            onEdit: () async {
              await context.push('/prescriptions/${widget.prescriptionId}/edit');
              if (context.mounted) {
                context.read<PrescriptionDetailCubit>().loadPrescription(widget.prescriptionId);
              }
            },
          ),
          body: switch (state) {
            PrescriptionDetailLoading() => const PrescriptionShimmer(),
            PrescriptionDetailError(:final failure) => AppErrorWidget(
                failure: failure,
                onRetry: () => context.read<PrescriptionDetailCubit>().loadPrescription(widget.prescriptionId),
              ),
            PrescriptionDetailLoaded(:final prescription) => ListView(
                padding: AppSpacing.pagePadding,
                children: [
                  _buildHeaderCard(context, prescription),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${'prescription.items'.tr()} (${prescription.items.length})',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: prescription.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      return PrescriptionItemTile(
                        index: index,
                        item: prescription.items[index],
                      );
                    },
                  ),
                  if (prescription.notes != null && prescription.notes!.trim().isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _buildNotesCard(context, prescription.notes!),
                  ],
                ],
              ),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }

  Widget _buildHeaderCard(BuildContext context, dynamic rx) {
    final dateStr = rx.createdAt != null ? DateFormat('yyyy/MM/dd – hh:mm a').format(rx.createdAt!) : '';

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.6)),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rx.prescriptionNumber,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              ),
              _buildPrintedBadge(context, rx.isPrinted),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(dateStr, style: AppTypography.bodySmall.copyWith(color: context.textSecondaryColor)),
          const SizedBox(height: AppSpacing.sm),
          Divider(color: context.dividerColor.withValues(alpha: 0.5), height: 1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.person_outline_rounded, size: 18, color: context.primaryColor),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${'prescription.patient'.tr()}: ',
                style: AppTypography.bodySmall.copyWith(color: context.textSecondaryColor),
              ),
              Text(
                rx.patient.fullName,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrintedBadge(BuildContext context, bool isPrinted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (isPrinted ? context.primaryColor : AppColors.warning).withValues(alpha: 0.12),
        borderRadius: AppRadius.chipRadius,
      ),
      child: Text(
        isPrinted ? 'prescription.printed'.tr() : 'prescription.not_printed'.tr(),
        style: AppTypography.labelSmall.copyWith(
          color: isPrinted ? context.primaryColor : AppColors.warning,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, String notes) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notes_rounded, size: 16, color: context.primaryColor),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'prescription.notes'.tr(),
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(notes, style: AppTypography.bodyMedium.copyWith(color: context.textSecondaryColor)),
        ],
      ),
    );
  }
}
