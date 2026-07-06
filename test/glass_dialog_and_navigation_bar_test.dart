import 'package:adaptive_ui_kit/adaptive_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LiquidGlassDialog uses provided title and message alignment', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  LiquidGlassDialog.showConfirm(
                    context: context,
                    title: 'Hello title',
                    message: 'Hello body',
                    titleAlign: TextAlign.left,
                    messageAlign: TextAlign.right,
                  );
                },
                child: const Text('Show dialog'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show dialog'));
    await tester.pumpAndSettle();

    final titleText = tester.widget<Text>(find.text('Hello title'));
    final messageText = tester.widget<Text>(find.text('Hello body'));

    expect(titleText.textAlign, TextAlign.left);
    expect(messageText.textAlign, TextAlign.right);
  });

  testWidgets('GlassNavigationBar uses a solid background color when provided',
      (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassNavigationBar(
            currentIndex: 0,
            backgroundColor: Colors.red,
            items: const [
              AdaptiveNavItem(icon: Icons.home, label: 'Home'),
            ],
          ),
        ),
      ),
    );

    final backgroundContainer =
        tester.widgetList<Container>(find.byType(Container)).firstWhere(
      (container) {
        final decoration = container.decoration;
        return decoration is BoxDecoration && decoration.color == Colors.red;
      },
    );

    expect(backgroundContainer.decoration, isA<BoxDecoration>());
    expect((backgroundContainer.decoration as BoxDecoration).color, Colors.red);
  });
}
