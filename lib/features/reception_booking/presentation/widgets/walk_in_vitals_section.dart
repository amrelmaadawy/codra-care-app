import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'walk_in_vital_field.dart';
import 'walk_in_vitals_header.dart';

class WalkInVitalsSection extends StatefulWidget {
  final Map<String, dynamic> vitalSigns;
  final void Function(String key, dynamic value) onVitalChanged;

  const WalkInVitalsSection({
    super.key,
    required this.vitalSigns,
    required this.onVitalChanged,
  });

  @override
  State<WalkInVitalsSection> createState() => _WalkInVitalsSectionState();
}

class _WalkInVitalsSectionState extends State<WalkInVitalsSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          WalkInVitalsHeader(
            isExpanded: _isExpanded,
            onToggle: () => setState(() => _isExpanded = !_isExpanded),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: WalkInVitalField(
                          label: 'reception_booking.vital_blood_pressure'.tr(),
                          hint: 'reception_booking.vital_blood_pressure_hint'.tr(),
                          keyName: 'blood_pressure',
                          keyboardType: TextInputType.text,
                          initialValue: widget.vitalSigns['blood_pressure'],
                          onVitalChanged: widget.onVitalChanged,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: WalkInVitalField(
                          label: 'reception_booking.vital_pulse'.tr(),
                          hint: '75',
                          keyName: 'pulse',
                          keyboardType: TextInputType.number,
                          initialValue: widget.vitalSigns['pulse'],
                          onVitalChanged: widget.onVitalChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: WalkInVitalField(
                          label: 'reception_booking.vital_temperature'.tr(),
                          hint: '37.0',
                          keyName: 'temperature',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          initialValue: widget.vitalSigns['temperature'],
                          onVitalChanged: widget.onVitalChanged,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: WalkInVitalField(
                          label: 'reception_booking.vital_oxygen_level'.tr(),
                          hint: '98',
                          keyName: 'oxygen_level',
                          keyboardType: TextInputType.number,
                          initialValue: widget.vitalSigns['oxygen_level'],
                          onVitalChanged: widget.onVitalChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: WalkInVitalField(
                          label: 'reception_booking.vital_weight'.tr(),
                          hint: '70',
                          keyName: 'weight_kg',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          initialValue: widget.vitalSigns['weight_kg'],
                          onVitalChanged: widget.onVitalChanged,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: WalkInVitalField(
                          label: 'reception_booking.vital_height'.tr(),
                          hint: '170',
                          keyName: 'height_cm',
                          keyboardType: TextInputType.number,
                          initialValue: widget.vitalSigns['height_cm'],
                          onVitalChanged: widget.onVitalChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: WalkInVitalField(
                          label: 'reception_booking.vital_blood_sugar'.tr(),
                          hint: '100',
                          keyName: 'blood_sugar',
                          keyboardType: TextInputType.number,
                          initialValue: widget.vitalSigns['blood_sugar'],
                          onVitalChanged: widget.onVitalChanged,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: WalkInVitalField(
                          label: 'reception_booking.vital_respiratory_rate'.tr(),
                          hint: '16',
                          keyName: 'respiratory_rate',
                          keyboardType: TextInputType.number,
                          initialValue: widget.vitalSigns['respiratory_rate'],
                          onVitalChanged: widget.onVitalChanged,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
