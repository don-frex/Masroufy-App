// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expenses_monthly/main.dart';

void main() {
  testWidgets('App loads and displays home screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ExpenseTrackerApp());
    await tester.pumpAndSettle();

    // Tap Start button on Splash Screen
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Fill Onboarding Form
    await tester.enterText(
        find.byType(TextFormField).first, 'Test User'); // Name
    await tester.enterText(find.byType(TextFormField).last, '5000'); // Budget
    await tester.pump();

    // Tap Continue
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Verify that the home screen is displayed
    expect(find.text('Hello,'), findsOneWidget);
    expect(find.text('Recent transactions'), findsOneWidget);

    // Test Adding a Transaction with "Today" date (Midnight)
    // 1. Open Add Modal
    await tester.tap(find.byIcon(CupertinoIcons.add));
    await tester.pumpAndSettle();

    // 2. Enter Amount and Title
    await tester.enterText(find.byType(TextField).first, '100'); // Amount
    await tester.enterText(
        find.byType(TextField).last, 'Test Expense'); // Title

    // 3. Pick Date (Today - returns midnight)
    await tester.tap(find.byIcon(CupertinoIcons.calendar));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // Confirm date picker
    await tester.pumpAndSettle();

    // 4. Submit
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // 5. Verify it appears in the list (Today filter is default)
    expect(find.text('Test Expense'), findsOneWidget);
  });
}
