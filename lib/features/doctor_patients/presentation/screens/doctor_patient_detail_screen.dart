import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../cubit/patient_detail_cubit.dart';
import '../cubit/patient_detail_state.dart';
import '../widgets/patient_detail_app_bar.dart';
import '../widgets/patient_detail_shimmer.dart';
import '../widgets/patient_info_card.dart';
import '../widgets/patient_medical_history_card.dart';
import '../widgets/patient_stats_strip.dart';
import '../widgets/patient_visit_card.dart';

class DoctorPatientDetailScreen extends StatefulWidget {
  final int patientId;

  const DoctorPatientDetailScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<DoctorPatientDetailScreen> createState() =>
      _DoctorPatientDetailScreenState();
}

class _DoctorPatientDetailScreenState extends State<DoctorPatientDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PatientDetailCubit>().loadPatientDetail(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientDetailCubit, PatientDetailState>(
      builder: (context, state) {
        final patientName = state is PatientDetailLoaded
            ? state.detail.patient.name
            : 'doctor_patients.patient_details'.tr();
        final patientCode = state is PatientDetailLoaded
            ? state.detail.patient.code
            : null;

        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: PatientDetailAppBar(
            title: patientName,
            code: patientCode,
            patientId: widget.patientId,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PatientDetailState state) {
    return switch (state) {
      PatientDetailLoading() => const PatientDetailShimmer(),
      PatientDetailError(:final failure) => AppErrorWidget(
          failure: failure,
          onRetry: () => context
              .read<PatientDetailCubit>()
              .loadPatientDetail(widget.patientId),
        ),
      PatientDetailLoaded(:final detail) => RefreshIndicator(
          color: context.primaryColor,
          onRefresh: () => context
              .read<PatientDetailCubit>()
              .loadPatientDetail(widget.patientId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PatientInfoCard(patient: detail.patient),
                const SizedBox(height: AppSpacing.md),
                PatientStatsStrip(stats: detail.stats),
                const SizedBox(height: AppSpacing.md),
                PatientMedicalHistoryCard(
                  medicalHistory: detail.medicalHistory,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildVisitsSection(context, detail.visits),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildVisitsSection(
    BuildContext context,
    List<dynamic> visits,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history_edu_rounded,
              size: 18,
              color: context.primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              '${'doctor_patients.visits_history'.tr()} (${visits.length})',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: context.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (visits.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.dividerColor.withValues(alpha: 0.4),
              ),
            ),
            child: Center(
              child: Text(
                'doctor_patients.no_visits_history'.tr(),
                style: AppTypography.bodySmall.copyWith(
                  color: context.textMutedColor,
                ),
              ),
            ),
          )
        else
          ...visits.map((v) => PatientVisitCard(visit: v)),
      ],
    );
  }
}
