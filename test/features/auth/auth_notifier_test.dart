import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:hair_dryer_app/src/features/auth/domain/failures/auth_failure.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/services/auth_local_service.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        authLocalServiceProvider.overrideWithValue(AuthLocalService()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<AuthNotifier> boot(ProviderContainer container) async {
    await container.read(authNotifierProvider.future);
    final notifier = container.read(authNotifierProvider.notifier);
    return notifier;
  }

  group('AuthNotifier session', () {
    test('Given no stored session, When the notifier boots, '
        'Then nobody is signed in', () async {
      final container = makeContainer();

      final user = await container.read(authNotifierProvider.future);

      expect(user, isNull);
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('Given valid details, When registered, '
        'Then the account is signed in and no failure is reported', () async {
      final container = makeContainer();
      final notifier = await boot(container);

      final ok = await notifier.register(
        name: 'Ana Diaz',
        email: 'ana@example.com',
        password: 'Sunset!Barber9',
      );

      expect(ok, isTrue);
      expect(
        container.read(authNotifierProvider).value?.email,
        'ana@example.com',
      );
      expect(container.read(authFailureProvider), isNull);
    });

    test('Given a signed-in guest, When logged out, '
        'Then the session and failure are cleared', () async {
      final container = makeContainer();
      final notifier = await boot(container);
      await notifier.loginAsGuest();

      await notifier.logout();

      expect(container.read(authNotifierProvider).value, isNull);
      expect(container.read(authFailureProvider), isNull);
    });
  });

  group('AuthNotifier failures', () {
    test('Given wrong credentials, When logged in, '
        'Then invalidCredentials is reported while signed out', () async {
      final container = makeContainer();
      final notifier = await boot(container);

      final ok = await notifier.login(
        email: 'ghost@example.com',
        password: 'Nope1234',
      );

      expect(ok, isFalse);
      expect(container.read(authNotifierProvider).value, isNull);
      expect(
        container.read(authFailureProvider),
        const AuthFailure.invalidCredentials(),
      );
    });

    test('Given a signed-in guest, When another attempt fails, '
        'Then the session survives the failure', () async {
      final container = makeContainer();
      final notifier = await boot(container);
      await notifier.loginAsGuest();

      final ok = await notifier.login(
        email: 'ghost@example.com',
        password: 'Nope1234',
      );

      expect(ok, isFalse);
      expect(container.read(authNotifierProvider).value?.isGuest, isTrue);
      expect(
        container.read(authFailureProvider),
        const AuthFailure.invalidCredentials(),
      );
    });

    test('Given a reported failure, When a later attempt succeeds, '
        'Then the failure is cleared', () async {
      final container = makeContainer();
      final notifier = await boot(container);
      await notifier.login(email: 'ghost@example.com', password: 'Nope1234');

      final ok = await notifier.loginAsGuest();

      expect(ok, isTrue);
      expect(container.read(authFailureProvider), isNull);
    });

    test('Given a weak password, When registered, '
        'Then weakPassword is reported', () async {
      final container = makeContainer();
      final notifier = await boot(container);

      final ok = await notifier.register(
        name: 'Ana Diaz',
        email: 'ana@example.com',
        password: 'abcdefgh',
      );

      expect(ok, isFalse);
      expect(
        container.read(authFailureProvider),
        const AuthFailure.weakPassword(),
      );
    });
  });

  group('AuthNotifier.updateProfile', () {
    test('Given nobody signed in, When a profile is updated, '
        'Then nothing is written', () async {
      final container = makeContainer();
      final notifier = await boot(container);

      final ok = await notifier.updateProfile(
        name: 'Ana Diaz',
        email: 'ana@example.com',
        phone: '+1 555 0100',
      );

      expect(ok, isFalse);
      expect(container.read(authNotifierProvider).value, isNull);
    });
  });
}
