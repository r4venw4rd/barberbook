import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/app.dart';
import 'package:hair_dryer_app/src/core/database/local_storage_service.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/services/auth_local_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider overrides every widget test boots with: onboarding already
/// finished and one shared in-memory auth store.
Future<List<Override>> appOverrides({
  List<Override> extra = const <Override>[],
}) async {
  SharedPreferences.setMockInitialValues({'has_seen_onboarding_v1': true});
  final prefs = await SharedPreferences.getInstance();
  return [
    localStorageProvider.overrideWithValue(LocalStorageService(prefs)),
    authLocalServiceProvider.overrideWithValue(AuthLocalService()),
    ...extra,
  ];
}

/// Signs the guest user in through the real repository so splash and router
/// resolve a genuine stored session.
Future<void> seedSignedInSession(List<Override> overrides) async {
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  final result = await container.read(authRepositoryProvider).loginAsGuest();
  expect(result.isRight(), isTrue);
}

/// Stores a password account without a session, for sign-in tests.
Future<void> seedRegisteredAccount(List<Override> overrides) async {
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  final repository = container.read(authRepositoryProvider);
  final registered = await repository.register(
    name: 'Ana Diaz',
    email: 'ana@example.com',
    password: 'Sunset!Barber9',
  );
  expect(registered.isRight(), isTrue);
  final loggedOut = await repository.logout();
  expect(loggedOut.isRight(), isTrue);
}

/// Lets pending async work and a route transition finish with bounded pumps.
///
/// Used instead of [WidgetTester.pumpAndSettle] whenever the destination can
/// be home, whose scissors animation never settles.
Future<void> pumpNavigation(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

/// Pumps the app and waits for the splash transition to land.
///
/// Splash auto-navigates after 1700ms and home runs the scissors animation,
/// so this waits with bounded pumps instead of [WidgetTester.pumpAndSettle].
Future<void> pumpApp(
  WidgetTester tester, {
  required List<Override> overrides,
}) async {
  await tester.pumpWidget(
    ProviderScope(overrides: overrides, child: const BarberBookApp()),
  );
  await tester.pump(const Duration(milliseconds: 1700));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}
