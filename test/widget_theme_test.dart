import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/features/profile/application/notifiers/appearance_notifier.dart';
import 'package:hair_dryer_app/src/features/profile/application/notifiers/locale_notifier.dart';
import 'helpers/app_harness.dart';
import 'helpers/app_test_overrides.dart';

void main() {
  testWidgets('Given dark mode appearance override, '
      'When rendered, '
      'Then theme is dark and funnel renders correctly', (tester) async {
    final overrides = await appOverrides(
      extra: [
        appearanceProvider.overrideWith(DarkAppearanceForTest.new),
        localeProvider.overrideWith(EnglishLocaleForTest.new),
      ],
    );
    await seedSignedInSession(overrides);
    await pumpApp(tester, overrides: overrides);

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );

    await tester.tap(find.text('Book appointment').first);
    await tester.pumpAndSettle();
    expect(find.text('Choose a service'), findsOneWidget);

    await tester.tap(find.text('Skin Fade').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Pick your barber'), findsOneWidget);
  });
}
