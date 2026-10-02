import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/features/auth/domain/failures/auth_failure.dart';
import 'auth_repository_test_support.dart';

void main() {
  late AuthRepositoryHarness harness;
  setUp(() async {
    harness = AuthRepositoryHarness();
    await harness.setUp();
  });
  tearDown(() => harness.tearDown());

    group('AuthRepository.login', () {
      test('Given correct credentials, When logged in, '
          'Then the account is returned and a session starts', () async {
        final registered = await harness.registerAna();
  
        final result = await harness.repository.login(
          email: 'ana@example.com',
          password: 'Sunset!Barber9',
        );
  
        expect(authValue(result).id, registered.id);
        expect(authValue(await harness.repository.getCurrentUser())?.id, registered.id);
      });
  
      test('Given a wrong password, When logged in, '
          'Then invalidCredentials is returned', () async {
        await harness.registerAna();
  
        final result = await harness.repository.login(
          email: 'ana@example.com',
          password: 'WrongPass1',
        );
  
        expect(authFailure(result), const AuthFailure.invalidCredentials());
      });
  
      test('Given an unknown email, When logged in, '
          'Then invalidCredentials is returned', () async {
        final result = await harness.repository.login(
          email: 'nobody@example.com',
          password: 'Sunset!Barber9',
        );
  
        expect(authFailure(result), const AuthFailure.invalidCredentials());
      });
  
      test('Given the guest profile, When a password login is attempted, '
          'Then invalidCredentials is returned', () async {
        authValue(await harness.repository.loginAsGuest());
  
        final result = await harness.repository.login(
          email: 'guest@barberbook.local',
          password: 'Sunset!Barber9',
        );
  
        expect(authFailure(result), const AuthFailure.invalidCredentials());
      });
    });
}
