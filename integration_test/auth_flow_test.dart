import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fittrack/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration Test', () {
    testWidgets('login flow works', (
      WidgetTester tester,
    ) async {
      app.main();

      await tester.pumpAndSettle();

      // Enter email
      await tester.enterText(
        find.byKey(const Key('emailField')),
        'test@email.com',
      );

      // Enter password
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        '123456',
      );

      // Tap login
      await tester.tap(
        find.byKey(const Key('loginButton')),
      );

      await tester.pumpAndSettle();

      // Verify dashboard appears
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}

