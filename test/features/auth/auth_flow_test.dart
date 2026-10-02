import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/features/profile/application/notifiers/locale_notifier.dart';

import '../../helpers/app_harness.dart';

void main() {
  Future<void> pumpAuthApp(WidgetTester tester) async {
    final overrides = await appOverrides(
      extra: [localeProvider.overrideWith(_EnLocale.new)],
    );
    await pumpApp(tester, overrides: overrides);
  }

  Future<void> pumpAuthAppWithAccount(WidgetTester tester) async {
    final overrides = await appOverrides(
      extra: [localeProvider.overrideWith(_EnLocale.new)],
    );
    await seedRegisteredAccount(overrides);
    await pumpApp(tester, overrides: overrides);
  }

  testWidgets('Given no stored session, When launched, '
      'Then the sign-in screen is shown', (tester) async {
    await pumpAuthApp(tester);

    expect(find.text('Account & Sign In'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Book appointment'), findsNothing);
  });

  testWidgets('Given an existing account, When credentials are submitted, '
      'Then the home screen opens', (tester) async {
    await pumpAuthAppWithAccount(tester);

    await tester.enterText(find.byType(TextField).at(0), 'ana@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'Sunset!Barber9');
    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await pumpNavigation(tester);

    expect(find.text('Account & Sign In'), findsNothing);
    expect(find.text('Book appointment'), findsWidgets);
  });

  testWidgets('Given wrong credentials, When submitted, '
      'Then an error appears while the session stays closed', (tester) async {
    await pumpAuthApp(tester);

    await tester.enterText(find.byType(TextField).at(0), 'ghost@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'Nope1234');
    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Incorrect email or password'), findsOneWidget);
    expect(find.text('Account & Sign In'), findsOneWidget);
    expect(find.text('Book appointment'), findsNothing);
  });

  testWidgets('Given the sign-in form, When continued as guest, '
      'Then the home screen opens', (tester) async {
    await pumpAuthApp(tester);

    final guestButton = find.text('Continue as Guest');
    await tester.ensureVisible(guestButton);
    await tester.tap(guestButton);
    await pumpNavigation(tester);

    expect(find.text('Book appointment'), findsWidgets);
  });

  testWidgets('Given the sign-up form, When details are submitted, '
      'Then the account is created and home opens', (tester) async {
    await pumpAuthApp(tester);

    final toggle = find.text("Don't have an account? Create account");
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pump();

    await tester.enterText(find.byType(TextField).at(0), 'Ana Diaz');
    await tester.enterText(find.byType(TextField).at(1), 'ana@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'Sunset!Barber9');
    await tester.enterText(find.byType(TextField).at(3), 'Sunset!Barber9');

    final submit = find.text('Create account');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await pumpNavigation(tester);

    expect(find.text('Account & Sign In'), findsNothing);
    expect(find.text('Book appointment'), findsWidgets);
  });
}

class _EnLocale extends LocaleNotifier {
  @override
  Locale? build() => const Locale('en');
}
