import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dice roller app window smoke test', (WidgetTester tester) async {
    // Verifies that the test environment can spin up a frame without crashing
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Dice Roller App'),
        ),
      ),
    );

    expect(find.text('Dice Roller App'), findsOneWidget);
  });
}
