import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/prescription/presentation/widgets/prescription_notes_card.dart';

void main() {
  Widget buildWidget({
    required String notes,
    List<String> quickNotes = const ['راحة تامة', 'سوائل دافئة'],
    required ValueChanged<String> onChanged,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: PrescriptionNotesCard(
          notes: notes,
          quickNotes: quickNotes,
          onChanged: onChanged,
        ),
      ),
    );
  }

  testWidgets('renders notes text field and quick notes chips', (tester) async {
    await tester.pumpWidget(
      buildWidget(notes: 'Initial note', onChanged: (_) {}),
    );

    expect(find.text('Initial note'), findsOneWidget);
    expect(find.text('راحة تامة'), findsOneWidget);
    expect(find.text('سوائل دافئة'), findsOneWidget);
  });

  testWidgets('tapping quick note chip appends it to notes and calls onChanged', (tester) async {
    String currentNotes = '';
    await tester.pumpWidget(
      buildWidget(
        notes: currentNotes,
        onChanged: (val) => currentNotes = val,
      ),
    );

    await tester.tap(find.text('راحة تامة'));
    await tester.pumpAndSettle();

    expect(currentNotes, 'راحة تامة');
    expect(find.text('راحة تامة'), findsNWidgets(2)); // in TextField and chip
  });

  testWidgets('tapping another chip appends with newline', (tester) async {
    String currentNotes = 'راحة تامة';
    await tester.pumpWidget(
      buildWidget(
        notes: currentNotes,
        onChanged: (val) => currentNotes = val,
      ),
    );

    await tester.tap(find.text('سوائل دافئة'));
    await tester.pumpAndSettle();

    expect(currentNotes, 'راحة تامة\nسوائل دافئة');
  });

  testWidgets('tapping already selected chip removes it (toggle)', (tester) async {
    String currentNotes = 'راحة تامة\nسوائل دافئة';
    await tester.pumpWidget(
      buildWidget(
        notes: currentNotes,
        onChanged: (val) => currentNotes = val,
      ),
    );

    await tester.tap(find.text('راحة تامة'));
    await tester.pumpAndSettle();

    expect(currentNotes, 'سوائل دافئة');
  });
}
