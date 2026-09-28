import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';

class WalkInVitalField extends StatelessWidget {
  final String label;
  final String hint;
  final String keyName;
  final TextInputType keyboardType;
  final dynamic initialValue;
  final String? Function(String? value)? validator;
  final void Function(String key, dynamic value) onVitalChanged;

  const WalkInVitalField({
    super.key,
    required this.label,
    required this.hint,
    required this.keyName,
    required this.keyboardType,
    this.initialValue,
    this.validator,
    required this.onVitalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue?.toString() ?? '',
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        errorMaxLines: 2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
        ),
      ),
      onChanged: (val) {
        final trimmed = val.trim();
        if (trimmed.isEmpty) {
          onVitalChanged(keyName, null);
        } else if (keyboardType == TextInputType.number) {
          onVitalChanged(keyName, int.tryParse(trimmed) ?? trimmed);
        } else if (keyboardType.decimal == true) {
          onVitalChanged(keyName, double.tryParse(trimmed) ?? trimmed);
        } else {
          onVitalChanged(keyName, trimmed);
        }
      },
    );
  }
}
