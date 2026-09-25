import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/create_appointment_params.dart';

class InlineNewPatientForm extends StatefulWidget {
  final NewPatientParams? initialValue;
  final ValueChanged<NewPatientParams?> onChanged;

  const InlineNewPatientForm({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<InlineNewPatientForm> createState() => _InlineNewPatientFormState();
}

class _InlineNewPatientFormState extends State<InlineNewPatientForm> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String _gender = 'male';

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _nameCtrl.text = widget.initialValue!.fullName;
      _phoneCtrl.text = widget.initialValue!.phone;
      _gender = widget.initialValue!.gender;
      if (widget.initialValue!.age != null) {
        _ageCtrl.text = widget.initialValue!.age.toString();
      }
      _addressCtrl.text = widget.initialValue!.address ?? '';
    }
    _nameCtrl.addListener(_notify);
    _phoneCtrl.addListener(_notify);
    _ageCtrl.addListener(_notify);
    _addressCtrl.addListener(_notify);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    if (name.length < 3 || phone.length < 9) {
      widget.onChanged(null);
      return;
    }
    final age = int.tryParse(_ageCtrl.text.trim());
    widget.onChanged(
      NewPatientParams(
        fullName: name,
        phone: phone,
        gender: _gender,
        age: age,
        address: _addressCtrl.text.trim().isNotEmpty
            ? _addressCtrl.text.trim()
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nameCtrl,
          decoration: InputDecoration(
            labelText: 'reception_booking.patient_name_label'.tr(),
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'reception_booking.patient_phone_label'.tr(),
            prefixIcon: const Icon(Icons.phone_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'male',
                    label: Text('reception_booking.gender_male'.tr()),
                    icon: const Icon(Icons.male),
                  ),
                  ButtonSegment(
                    value: 'female',
                    label: Text('reception_booking.gender_female'.tr()),
                    icon: const Icon(Icons.female),
                  ),
                ],
                selected: {_gender},
                onSelectionChanged: (val) {
                  setState(() => _gender = val.first);
                  _notify();
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 90,
              child: TextField(
                controller: _ageCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'reception_booking.age_label'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _addressCtrl,
          decoration: InputDecoration(
            labelText: 'reception_booking.address_label'.tr(),
            prefixIcon: const Icon(Icons.location_on_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ),
      ],
    );
  }
}
