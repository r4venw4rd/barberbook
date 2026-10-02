import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/features/profile/application/notifiers/locale_notifier.dart';
import 'helpers/app_harness.dart';
import 'helpers/app_test_overrides.dart';

void main() {
  testWidgets('Given user switches language to Turkish, '
      'When Profile language selector is used, '
      'Then UI updates to Turkish across entire app', (tester) async {
    final overrides = await appOverrides(
      extra: [localeProvider.overrideWith(EnglishLocaleForTest.new)],
    );
    await seedSignedInSession(overrides);
    await pumpApp(tester, overrides: overrides);

    // Navigate to Profile tab via NavigationBar item
    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pumpAndSettle();

    // Scroll down to Language section and select Türkçe
    await tester.scrollUntilVisible(find.text('Türkçe'), 300);
    await tester.tap(find.text('Türkçe'));
    await tester.pumpAndSettle();

    // Verify Turkish labels in bottom navigation & headers
    expect(find.text('Profil'), findsWidgets);
    expect(find.text('Randevular'), findsWidgets);
    expect(find.text('Ana Sayfa'), findsWidgets);

    // Navigate to Home tab via Home icon
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pump(const Duration(milliseconds: 200));

    await tester.scrollUntilVisible(find.text('Hizmetler'), 100);
    expect(find.text('Hizmetler'), findsOneWidget);
    expect(find.text('Randevu al'), findsWidgets);
    expect(find.text('Klasik Kesim'), findsWidgets);

    // Enter booking funnel and verify Turkish step
    await tester.tap(find.text('Randevu al').first);
    await tester.pumpAndSettle();
    expect(find.text('Hizmet seçin'), findsOneWidget);
    expect(find.text('1. Adım / 4'), findsOneWidget);
    expect(find.text('Devam Et'), findsOneWidget);
    expect(find.text('Klasik Kesim'), findsWidgets);
  });
}
