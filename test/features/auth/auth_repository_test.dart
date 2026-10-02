import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hair_dryer_app/src/core/database/app_database.dart';
import 'package:hair_dryer_app/src/features/auth/domain/entities/user.dart';
import 'package:hair_dryer_app/src/features/auth/domain/failures/auth_failure.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/repositories/auth_repository.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/services/auth_local_service.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/services/password_hasher.dart';
import 'package:hive_ce/hive_ce.dart';

T _value<T>(Either<AuthFailure, T> result) => result.fold(
  (failure) => fail('expected a value, got $failure'),
  (value) => value,
);

AuthFailure _failure<T>(Either<AuthFailure, T> result) => result.fold(
  (failure) => failure,
  (_) => fail('expected a failure, got a value'),
);

void main() {
  late Directory tempDir;
  late AppDatabase database;
  late AuthRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('bb_auth_repo_');
    database = await AppDatabase.openAt(tempDir.path);
    repository = AuthRepository(
      AuthLocalService(database),
      const PasswordHasher(iterations: 1),
    );
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  Future<User> registerAna() async {
    final result = await repository.register(
      name: '  Ana Diaz  ',
      email: 'Ana@Example.com',
      password: 'Sunset!Barber9',
    );
    final user = _value(result);
    return user;
  }

  group('AuthRepository.register', () {
    test('Given valid details, When registered, '
        'Then the account is stored and a session starts', () async {
      final user = await registerAna();

      expect(user.name, 'Ana Diaz');
      expect(user.email, 'ana@example.com');
      expect(user.isGuest, isFalse);

      final session = _value(await repository.getCurrentUser());
      expect(session?.id, user.id);
      expect(database.session.get(AppDatabase.sessionKey), isNotNull);
    });

    test('Given the same email with different casing, When registered again, '
        'Then userAlreadyExists is returned', () async {
      await registerAna();

      final result = await repository.register(
        name: 'Other Person',
        email: '  ANA@example.COM ',
        password: 'Sunset!Barber9',
      );

      expect(_failure(result), const AuthFailure.userAlreadyExists());
    });

    test('Given a malformed email, When registered, '
        'Then invalidEmail is returned', () async {
      final result = await repository.register(
        name: 'Ana Diaz',
        email: 'not-an-email',
        password: 'Sunset!Barber9',
      );

      expect(_failure(result), const AuthFailure.invalidEmail());
    });

    test('Given a password without a digit, When registered, '
        'Then weakPassword is returned', () async {
      final result = await repository.register(
        name: 'Ana Diaz',
        email: 'ana@example.com',
        password: 'abcdefgh',
      );

      expect(_failure(result), const AuthFailure.weakPassword());
    });

    test('Given an empty name, When registered, '
        'Then unexpected is returned', () async {
      final result = await repository.register(
        name: '   ',
        email: 'ana@example.com',
        password: 'Sunset!Barber9',
      );

      expect(
        _failure(result),
        const AuthFailure.unexpected('Name cannot be empty'),
      );
    });

    test('Given a registered account, When the raw record is inspected, '
        'Then the password is stored only as a hash', () async {
      final user = await registerAna();

      final record = database.users.get(user.id);

      expect(record, isNotNull);
      expect(record!['passwordHash'], isNot('Sunset!Barber9'));
      expect('$record', isNot(contains('Sunset!Barber9')));
    });
  });

  group('AuthRepository.login', () {
    test('Given correct credentials, When logged in, '
        'Then the account is returned and a session starts', () async {
      final registered = await registerAna();

      final result = await repository.login(
        email: 'ana@example.com',
        password: 'Sunset!Barber9',
      );

      expect(_value(result).id, registered.id);
      expect(_value(await repository.getCurrentUser())?.id, registered.id);
    });

    test('Given a wrong password, When logged in, '
        'Then invalidCredentials is returned', () async {
      await registerAna();

      final result = await repository.login(
        email: 'ana@example.com',
        password: 'WrongPass1',
      );

      expect(_failure(result), const AuthFailure.invalidCredentials());
    });

    test('Given an unknown email, When logged in, '
        'Then invalidCredentials is returned', () async {
      final result = await repository.login(
        email: 'nobody@example.com',
        password: 'Sunset!Barber9',
      );

      expect(_failure(result), const AuthFailure.invalidCredentials());
    });

    test('Given the guest profile, When a password login is attempted, '
        'Then invalidCredentials is returned', () async {
      _value(await repository.loginAsGuest());

      final result = await repository.login(
        email: 'guest@barberbook.local',
        password: 'Sunset!Barber9',
      );

      expect(_failure(result), const AuthFailure.invalidCredentials());
    });
  });

  group('AuthRepository session', () {
    test('Given a signed-in user, When logged out, '
        'Then the session record is removed', () async {
      await registerAna();

      _value(await repository.logout());

      expect(_value(await repository.getCurrentUser()), isNull);
      expect(database.session.isEmpty, isTrue);
    });

    test('Given a stored session, When another repository opens the database, '
        'Then the session survives', () async {
      final registered = await registerAna();
      final reopened = AuthRepository(
        AuthLocalService(database),
        const PasswordHasher(iterations: 1),
      );

      final result = await reopened.getCurrentUser();

      expect(_value(result)?.id, registered.id);
    });

    test('Given an expired session, When restored, '
        'Then the user is null and the session is cleared', () async {
      await registerAna();
      final raw = Map<String, dynamic>.from(
        database.session.get(AppDatabase.sessionKey)!,
      );
      raw['expiresAt'] = DateTime.now()
          .toUtc()
          .subtract(const Duration(days: 1))
          .toIso8601String();
      await database.session.put(AppDatabase.sessionKey, raw);

      expect(_value(await repository.getCurrentUser()), isNull);
      expect(database.session.isEmpty, isTrue);
    });

    test('Given a session pointing at a deleted account, When restored, '
        'Then the user is null and the session is cleared', () async {
      final registered = await registerAna();
      await database.users.delete(registered.id);

      expect(_value(await repository.getCurrentUser()), isNull);
      expect(database.session.isEmpty, isTrue);
    });
  });

  group('AuthRepository.updateProfile', () {
    test('Given new profile details, When updated, '
        'Then the account is persisted', () async {
      final user = await registerAna();
      final updated = await repository.updateProfile(
        user.copyWith(name: 'Ana M.', phone: '+1 555 7788'),
      );

      final saved = _value(updated);
      expect(saved.name, 'Ana M.');
      expect(saved.phone, '+1 555 7788');
      expect(_value(await repository.getCurrentUser())?.name, 'Ana M.');
    });

    test('Given the email of another account, When updated, '
        'Then userAlreadyExists is returned', () async {
      await registerAna();
      final guest = _value(await repository.loginAsGuest());

      final result = await repository.updateProfile(
        guest.copyWith(email: 'ana@example.com'),
      );

      expect(_failure(result), const AuthFailure.userAlreadyExists());
    });

    test('Given an unknown account, When updated, '
        'Then userNotFound is returned', () async {
      final result = await repository.updateProfile(
        const User(
          id: 'usr-missing',
          name: 'Ghost',
          email: 'ghost@example.com',
          phone: '+1 555 0100',
        ),
      );

      expect(_failure(result), const AuthFailure.userNotFound());
    });
  });

  group('AuthRepository.loginAsGuest', () {
    test('When used, Then the throwaway guest profile is signed in', () async {
      final guest = _value(await repository.loginAsGuest());

      expect(guest.id, 'usr-guest');
      expect(guest.isGuest, isTrue);
      expect(_value(await repository.getCurrentUser())?.id, 'usr-guest');
    });
  });
}
