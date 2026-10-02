import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/features/profile/application/notifiers/locale_notifier.dart';
import 'helpers/app_harness.dart';
import 'helpers/app_test_overrides.dart';

void main() {
  testWidgets('Given app launch, '
      'When rendered, '
      'Then display home screen with booking entry points', (tester) async {
    final overrides = await appOverrides(
      extra: [localeProvider.overrideWith(EnglishLocaleForTest.new)],
    );
    await seedSignedInSession(overrides);
    await pumpApp(tester, overrides: overrides);

    expect(find.text('Book appointment'), findsWidgets);
    await tester.scrollUntilVisible(find.text('Services'), 100);
    expect(find.text('Services'), findsOneWidget);

    await tester.tap(find.text('Book appointment').first);
    await tester.pumpAndSettle();

    expect(find.text('Choose a service'), findsOneWidget);
    expect(find.text('Step 1 of 4'), findsOneWidget);
    expect(find.text('Classic Cut'), findsWidgets);
  });
}
