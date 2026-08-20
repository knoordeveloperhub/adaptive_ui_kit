import 'package:adaptive_ui_kit/adaptive_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Material date range picker uses the official range dialog',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => AdaptiveDateTimePicker.showDateRange(
              context: context,
              uiKit: AdaptiveUiKit.material,
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(DateRangePickerDialog), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
  });

  testWidgets('Glass date range picker resolves a selected range',
      (tester) async {
    DateTimeRange? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await AdaptiveDateTimePicker.showDateRange(
                context: context,
                uiKit: AdaptiveUiKit.glass,
                initialDateRange: DateTimeRange(
                  start: DateTime(2026, 8, 10),
                  end: DateTime(2026, 8, 10),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('12').last);
    await tester.tap(find.text('15').last);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.start, DateTime(2026, 8, 12));
    expect(result!.end, DateTime(2026, 8, 15));
  });
}
