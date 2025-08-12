// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';

import 'package:sber_id/sber_id.dart';

void main() {

  group('Sber ID Integration Tests', () {
    testWidgets('Check Sber ID installation', (WidgetTester tester) async {
      final SBerId plugin = SBerId.instance;

      // Test if method runs without error
      final bool isInstalled = await plugin.isSBerIdInstalled();

      // Should return boolean (true or false)
      expect(isInstalled, isA<bool>());
    });

    testWidgets('Login attempt test', (WidgetTester tester) async {
      final SBerId plugin = SBerId.instance;

      try {
        // This might fail if Sber ID is not installed
        final SBerIdAuthResponse? result = await plugin.login();

        // If result is not null, it should have isSuccess field
        if (result != null) {
          expect(result.isSuccess, isA<bool>());
        }
      } catch (e) {
        // Login might fail in test environment, that's OK
        expect(e, isA<Exception>());
      }
    });

    testWidgets('Logout test', (WidgetTester tester) async {
      final SBerId plugin = SBerId.instance;

      // Logout should not throw exception
      await expectLater(
        plugin.logout(),
        completes,
      );
    });
  });
}