import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../auth/presentation/cubits/auth_state.dart';
import '../../domain/entities/prescription_entity.dart';
import '../cubit/prescription_detail_cubit.dart';
import '../cubit/prescription_detail_state.dart';
import '../widgets/prescription_actions_bottom_sheet.dart';
import '../widgets/prescription_detail_app_bar.dart';
import '../widgets/prescription_detail_header_card.dart';
import '../widgets/prescription_detail_notes_card.dart';
import '../widgets/prescription_item_tile.dart';
import '../widgets/prescription_shimmer.dart';

class PrescriptionDetailScreen extends StatefulWidget {
  final int prescriptionId;

  const PrescriptionDetailScreen({super.key, required this.prescriptionId});

  @override
  State<PrescriptionDetailScreen> createState() =>
      _PrescriptionDetailScreenState();
}

class _PrescriptionDetailScreenState extends State<PrescriptionDetailScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<PrescriptionDetailCubit>()
        .loadPrescription(widget.prescriptionId);
  }

  void _showPdfActions(BuildContext context, PrescriptionEntity rx) {
    final authState = context.read<AuthCubit>().state;
    final doctorName =
        authState is AuthAuthenticated ? authState.user.name : null;

    PrescriptionActionsBottomSheet.show(
      context: context,
      prescription: rx,
      doctorName: doctorName,
      onPrinted: () {
        context.read<PrescriptionDetailCubit>().markPrinted(rx.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionDetailCubit, PrescriptionDetailState>(
      builder: (context, state) {
        final rx =
            state is PrescriptionDetailLoaded ? state.prescription : null;

        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: PrescriptionDetailAppBar(
            prescription: rx,
            onEdit: () async {
              await context.push(
                '/prescriptions/${widget.prescriptionId}/edit',
              );
              if (context.mounted) {
                context
                    .read<PrescriptionDetailCubit>()
                    .loadPrescription(widget.prescriptionId);
              }
            },
            onPdfAction: rx != null ? () => _showPdfActions(context, rx) : null,
          ),
          body: switch (state) {
            PrescriptionDetailLoading() => const PrescriptionShimmer(),
            PrescriptionDetailError(:final failure) => AppErrorWidget(
                failure: failure,
                onRetry: () => context
                    .read<PrescriptionDetailCubit>()
                    .loadPrescription(widget.prescriptionId),
              ),
            PrescriptionDetailLoaded(:final prescription) => ListView(
                padding: AppSpacing.pagePadding,
                children: [
                  PrescriptionDetailHeaderCard(prescription: prescription),
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
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      return PrescriptionItemTile(
                        index: index,
                        item: prescription.items[index],
                      );
                    },
                  ),
                  if (prescription.notes != null &&
                      prescription.notes!.trim().isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    PrescriptionDetailNotesCard(notes: prescription.notes!),
                  ],
                ],
              ),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}
