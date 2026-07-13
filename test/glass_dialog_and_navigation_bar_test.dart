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

  testWidgets('GlassNavigationBar uses larger icons and smaller labels', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassNavigationBar(
            currentIndex: 0,
            items: const [
              AdaptiveNavItem(icon: Icons.home, label: 'Home'),
            ],
          ),
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byType(Icon).first);
    final labelStyle = tester
        .widgetList<AnimatedDefaultTextStyle>(
          find.byType(AnimatedDefaultTextStyle),
        )
        .firstWhere(
          (style) =>
              style.child is Text && (style.child as Text).data == 'Home',
        );

    expect(icon.size, 28);
    expect(labelStyle.style.fontSize, 10);
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

  testWidgets(
      'Glass action sheet wraps long labels to three lines with ellipsis', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  LiquidGlassActionSheet.show(
                    context: context,
                    items: [
                      ActionSheetItem(
                        label:
                            'This is a very long action sheet label that should wrap',
                        icon: Icons.share,
                        onTap: () {},
                      ),
                    ],
                  );
                },
                child: const Text('Show action sheet'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show action sheet'));
    await tester.pumpAndSettle();

    final label =
        tester.widget<Text>(find.textContaining('This is a very long'));
    expect(label.softWrap, isTrue);
    expect(label.maxLines, 3);
    expect(label.overflow, TextOverflow.ellipsis);
  });

  testWidgets('Glass multi-select wraps long option labels', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  LiquidGlassMultiSelect.show(
                    context: context,
                    title: 'Options',
                    options: [
                      MultiSelectOption(
                        id: 'long',
                        label:
                            'This is a very long multi-select option label that should wrap',
                      ),
                    ],
                  );
                },
                child: const Text('Show multi-select'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show multi-select'));
    await tester.pumpAndSettle();

    final label =
        tester.widget<Text>(find.textContaining('This is a very long'));
    expect(label.softWrap, isTrue);
    expect(label.maxLines, 3);
    expect(label.overflow, TextOverflow.ellipsis);
  });
}
