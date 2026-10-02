import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/features/profile/application/notifiers/appearance_notifier.dart';
import 'package:hair_dryer_app/src/features/profile/application/notifiers/locale_notifier.dart';

import 'helpers/app_harness.dart';

void main() {
  testWidgets('Given app launch, '
      'When rendered, '
      'Then display home screen with booking entry points', (tester) async {
    final overrides = await appOverrides(
      extra: [localeProvider.overrideWith(_EnLocale.new)],
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

  testWidgets('Given user on home, '
      'When booking funnel is executed, '
      'Then complete appointment successfully', (tester) async {
    final overrides = await appOverrides(
      extra: [localeProvider.overrideWith(_EnLocale.new)],
    );
    await seedSignedInSession(overrides);
    await pumpApp(tester, overrides: overrides);

    await tester.tap(find.text('Book appointment').first);
    await tester.pumpAndSettle();

    // Step 1: service
    await tester.tap(find.text('Classic Cut').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 2: barber
    expect(find.text('Pick your barber'), findsOneWidget);
    expect(find.text('Step 2 of 4'), findsOneWidget);
    await tester.tap(find.text('Marcus Reed').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 3: date & time
    expect(find.text('Pick a date & time'), findsOneWidget);
    expect(find.text('Step 3 of 4'), findsOneWidget);

    // Move to first open day after today so slots are bookable.
    final now = DateTime.now();
    for (var i = 1; i <= 7; i++) {
      final day = now.add(Duration(days: i));
      if (day.weekday != DateTime.sunday) {
        final dayFinder = find.byKey(ValueKey('day-$i'));
        await tester.scrollUntilVisible(
          dayFinder,
          100,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(dayFinder);
        await tester.pumpAndSettle();
        break;
      }
    }

    final openSlot = find
        .byWidgetPredicate(
          (w) => w is Text && RegExp(r'^\d{2}:\d{2}$').hasMatch(w.data ?? ''),
        )
        .first;
    await tester.tap(openSlot);
    await tester.pumpAndSettle();
    expect(find.textContaining('Continue ·'), findsOneWidget);
    await tester.tap(find.textContaining('Continue ·'));
    await tester.pumpAndSettle();

    // Step 4: review & confirm
    expect(find.text('Review & confirm'), findsOneWidget);
    expect(find.text('Step 4 of 4'), findsOneWidget);
    expect(find.text('Classic Cut'), findsWidgets);
    await tester.scrollUntilVisible(find.byType(TextField), 240);
    await tester.enterText(find.byType(TextField), 'Keep the length on top');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm booking'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Success
    expect(find.text("You're booked!"), findsOneWidget);

    await tester.tap(find.text('View my appointments'));
    await tester.pumpAndSettle();
    expect(find.text('Your appointments'), findsOneWidget);
    expect(find.text('Classic Cut'), findsWidgets);
    expect(find.text('Confirmed'), findsWidgets);
  });

  testWidgets('Given dark mode appearance override, '
      'When rendered, '
      'Then theme is dark and funnel renders correctly', (tester) async {
    final overrides = await appOverrides(
      extra: [
        appearanceProvider.overrideWith(_DarkAppearance.new),
        localeProvider.overrideWith(_EnLocale.new),
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

  testWidgets('Given user inside booking funnel, '
      'When back button is tapped at each step, '
      'Then navigate back to previous step or home', (tester) async {
    final overrides = await appOverrides(
      extra: [localeProvider.overrideWith(_EnLocale.new)],
    );
    await seedSignedInSession(overrides);
    await pumpApp(tester, overrides: overrides);

    // Open booking funnel (Step 1)
    await tester.tap(find.text('Book appointment').first);
    await tester.pumpAndSettle();
    expect(find.text('Choose a service'), findsOneWidget);

    // Tap back from Step 1 -> Home
    await tester.tap(find.byTooltip('Back'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.scrollUntilVisible(find.text('Services'), 100);
    expect(find.text('Services'), findsOneWidget);
    expect(find.text('Choose a service'), findsNothing);

    // Enter again -> Step 1 -> select service -> Step 2
    await tester.tap(find.text('Book appointment').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Classic Cut').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Pick your barber'), findsOneWidget);

    // Tap back from Step 2 -> Step 1
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a service'), findsOneWidget);

    // Forward to Step 2 -> select barber -> Step 3
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Pick your barber'), findsOneWidget);
    await tester.tap(find.text('Marcus Reed').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Pick a date & time'), findsOneWidget);

    // Tap back from Step 3 -> Step 2
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Pick your barber'), findsOneWidget);
  });

  testWidgets('Given user switches language to Turkish, '
      'When Profile language selector is used, '
      'Then UI updates to Turkish across entire app', (tester) async {
    final overrides = await appOverrides(
      extra: [localeProvider.overrideWith(_EnLocale.new)],
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

class _DarkAppearance extends AppearanceNotifier {
  @override
  ThemeMode build() => ThemeMode.dark;
}

class _EnLocale extends LocaleNotifier {
  @override
  Locale? build() => const Locale('en');
}
