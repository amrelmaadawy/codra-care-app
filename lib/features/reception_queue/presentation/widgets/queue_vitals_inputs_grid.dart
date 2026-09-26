import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/queue_vitals_cubit.dart';
import '../cubit/queue_vitals_state.dart';

class QueueVitalsInputsGrid extends StatelessWidget {
  final QueueVitalsCubit cubit;
  final QueueVitalsState state;

  const QueueVitalsInputsGrid({
    super.key,
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildNumberField(
                label: 'reception_queue.bp_systolic'.tr(),
                hint: '120',
                initialValue: state.bpSystolic?.toString(),
                onChanged: (v) => cubit.setBpSystolic(int.tryParse(v)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildNumberField(
                label: 'reception_queue.bp_diastolic'.tr(),
                hint: '80',
                initialValue: state.bpDiastolic?.toString(),
                onChanged: (v) => cubit.setBpDiastolic(int.tryParse(v)),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _buildNumberField(
                label: 'reception_queue.temperature'.tr(),
                hint: '37.0',
                initialValue: state.temperature?.toString(),
                onChanged: (v) => cubit.setTemperature(double.tryParse(v)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildNumberField(
                label: 'reception_queue.pulse'.tr(),
                hint: '75',
                initialValue: state.pulse?.toString(),
                onChanged: (v) => cubit.setPulse(int.tryParse(v)),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _buildNumberField(
                label: 'reception_queue.weight_kg'.tr(),
                hint: '70',
                initialValue: state.weightKg?.toString(),
                onChanged: (v) => cubit.setWeightKg(double.tryParse(v)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildNumberField(
                label: 'reception_queue.height_cm'.tr(),
                hint: '170',
                initialValue: state.heightCm?.toString(),
                onChanged: (v) => cubit.setHeightCm(double.tryParse(v)),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _buildNumberField(
                label: 'reception_queue.oxygen_level'.tr(),
                hint: '98',
                initialValue: state.oxygenLevel?.toString(),
                onChanged: (v) => cubit.setOxygenLevel(double.tryParse(v)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildNumberField(
                label: 'reception_queue.respiratory_rate'.tr(),
                hint: '16',
                initialValue: state.respiratoryRate?.toString(),
                onChanged: (v) => cubit.setRespiratoryRate(int.tryParse(v)),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildBmiPreview(),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required String hint,
    String? initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildBmiPreview() {
    final bmi = state.computedBmi;
    if (bmi == null) return const SizedBox.shrink();

    String category = 'reception_queue.bmi_normal'.tr();
    Color color = AppColors.success;
    if (bmi < 18.5) {
      category = 'reception_queue.bmi_underweight'.tr();
      color = AppColors.info;
    } else if (bmi >= 25 && bmi < 30) {
      category = 'reception_queue.bmi_overweight'.tr();
      color = AppColors.warning;
    } else if (bmi >= 30) {
      category = 'reception_queue.bmi_obese'.tr();
      color = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Text(
            '${'reception_queue.bmi'.tr()}: $bmi',
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(width: 8),
          Text('($category)', style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}
