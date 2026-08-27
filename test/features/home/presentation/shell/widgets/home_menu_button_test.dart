import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/home_menu_button.dart';

void main() {
  Widget buildTestWidget({
    required TextDirection textDirection,
    required Widget drawer,
  }) {
    return MaterialApp(
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(
          drawer: drawer,
          body: const Stack(children: [HomeMenuButton()]),
        ),
      ),
    );
  }

  testWidgets('renders menu button on left in LTR and opens drawer on tap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildTestWidget(
        textDirection: TextDirection.ltr,
        drawer: const Drawer(child: Text('Drawer Content')),
      ),
    );

    final iconFinder = find.byIcon(Icons.menu);
    expect(iconFinder, findsOneWidget);

    // In LTR, start: 24 means left edge is at x ≈ 36 (24 padding + 12 icon container padding)
    final iconTopLeft = tester.getTopLeft(iconFinder);
    expect(iconTopLeft.dx, lessThan(100));

    // Tap to open drawer
    await tester.tap(iconFinder);
    await tester.pumpAndSettle();

    expect(find.text('Drawer Content'), findsOneWidget);
  });

  testWidgets(
    'renders menu button on right in RTL (Arabic) and opens drawer on tap',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestWidget(
          textDirection: TextDirection.rtl,
          drawer: const Drawer(child: Text('Drawer Content')),
        ),
      );

      final iconFinder = find.byIcon(Icons.menu);
      expect(iconFinder, findsOneWidget);

      // In RTL, start: 24 means button is anchored to right edge
      final iconTopRight = tester.getTopRight(iconFinder);
      expect(iconTopRight.dx, greaterThan(700));

      // Tap to open drawer
      await tester.tap(iconFinder);
      await tester.pumpAndSettle();

      expect(find.text('Drawer Content'), findsOneWidget);
    },
  );
}
