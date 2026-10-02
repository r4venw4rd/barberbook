import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/features/auth/domain/failures/auth_failure.dart';
import 'package:hair_dryer_app/src/core/database/app_database.dart';
import 'auth_repository_test_support.dart';

void main() {
  late AuthRepositoryHarness harness;
  setUp(() async {
    harness = AuthRepositoryHarness();
    await harness.setUp();
  });
  tearDown(() => harness.tearDown());

    group('AuthRepository.register', () {
      test('Given valid details, When registered, '
          'Then the account is stored and a session starts', () async {
        final user = await harness.registerAna();
  
        expect(user.name, 'Ana Diaz');
        expect(user.email, 'ana@example.com');
        expect(user.isGuest, isFalse);
  
        final session = authValue(await harness.repository.getCurrentUser());
        expect(session?.id, user.id);
        expect(harness.database.session.get(AppDatabase.sessionKey), isNotNull);
      });
  
      test('Given the same email with different casing, When registered again, '
          'Then userAlreadyExists is returned', () async {
        await harness.registerAna();
  
        final result = await harness.repository.register(
          name: 'Other Person',
          email: '  ANA@example.COM ',
          password: 'Sunset!Barber9',
        );
  
        expect(authFailure(result), const AuthFailure.userAlreadyExists());
      });
  
      test('Given a malformed email, When registered, '
          'Then invalidEmail is returned', () async {
        final result = await harness.repository.register(
          name: 'Ana Diaz',
          email: 'not-an-email',
          password: 'Sunset!Barber9',
        );
  
        expect(authFailure(result), const AuthFailure.invalidEmail());
      });
  
      test('Given a password without a digit, When registered, '
          'Then weakPassword is returned', () async {
        final result = await harness.repository.register(
          name: 'Ana Diaz',
          email: 'ana@example.com',
          password: 'abcdefgh',
        );
  
        expect(authFailure(result), const AuthFailure.weakPassword());
      });
  
      test('Given an empty name, When registered, '
          'Then unexpected is returned', () async {
        final result = await harness.repository.register(
          name: '   ',
          email: 'ana@example.com',
          password: 'Sunset!Barber9',
        );
  
        expect(
          authFailure(result),
          const AuthFailure.unexpected('Name cannot be empty'),
        );
      });
  
      test('Given a registered account, When the raw record is inspected, '
          'Then the password is stored only as a hash', () async {
        final user = await harness.registerAna();
  
        final record = harness.database.users.get(user.id);
  
        expect(record, isNotNull);
        expect(record!['passwordHash'], isNot('Sunset!Barber9'));
        expect('$record', isNot(contains('Sunset!Barber9')));
      });
    });
}
