import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/widgets/app_dropdown.dart';

void main() {
  Widget buildTestWidget({
    String? initialValue,
    List<String> items = const ['Patient A', 'Patient B', 'Patient C'],
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AppDropdown<String>(
            initialValue: initialValue,
            items: items,
            itemLabel: (item) => item,
            labelText: 'Patient',
            hintText: 'Select Patient',
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ),
    );
  }

  testWidgets('AppDropdown displays hintText when no item selected', (tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Select Patient'), findsOneWidget);
    expect(find.text('Patient'), findsOneWidget);
  });

  testWidgets('AppDropdown displays item label when initialValue is set', (tester) async {
    await tester.pumpWidget(buildTestWidget(initialValue: 'Patient B'));

    expect(find.text('Patient B'), findsOneWidget);
  });

  testWidgets('AppDropdown opens bottom sheet and selects item', (tester) async {
    String? selected;
    await tester.pumpWidget(buildTestWidget(
      onChanged: (val) => selected = val,
    ));

    // Tap to open sheet
    await tester.tap(find.text('Select Patient'));
    await tester.pumpAndSettle();

    // Verify items in sheet
    expect(find.text('Patient A'), findsOneWidget);
    expect(find.text('Patient B'), findsOneWidget);
    expect(find.text('Patient C'), findsOneWidget);

    // Tap on Patient B
    await tester.tap(find.text('Patient B'));
    await tester.pumpAndSettle();

    expect(selected, 'Patient B');
  });
}
