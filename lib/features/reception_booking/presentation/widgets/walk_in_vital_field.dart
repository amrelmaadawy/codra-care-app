import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';

class WalkInVitalField extends StatelessWidget {
  final String label;
  final String hint;
  final String keyName;
  final TextInputType keyboardType;
  final dynamic initialValue;
  final void Function(String key, dynamic value) onVitalChanged;

  const WalkInVitalField({
    super.key,
    required this.label,
    required this.hint,
    required this.keyName,
    required this.keyboardType,
    this.initialValue,
    required this.onVitalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue?.toString() ?? '',
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
        ),
      ),
      onChanged: (val) {
        if (keyboardType == TextInputType.number) {
          onVitalChanged(keyName, int.tryParse(val.trim()));
        } else if (keyboardType.decimal == true) {
          onVitalChanged(keyName, double.tryParse(val.trim()));
        } else {
          onVitalChanged(keyName, val.trim());
        }
      },
    );
  }
}
