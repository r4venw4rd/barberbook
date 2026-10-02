import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/features/auth/domain/failures/auth_failure.dart';
import 'package:hair_dryer_app/src/features/auth/domain/entities/user.dart';
import 'auth_repository_test_support.dart';

void main() {
  late AuthRepositoryHarness harness;
  setUp(() async {
    harness = AuthRepositoryHarness();
    await harness.setUp();
  });
  tearDown(() => harness.tearDown());

    group('AuthRepository.updateProfile', () {
      test('Given new profile details, When updated, '
          'Then the account is persisted', () async {
        final user = await harness.registerAna();
        final updated = await harness.repository.updateProfile(
          user.copyWith(name: 'Ana M.', phone: '+1 555 7788'),
        );
  
        final saved = authValue(updated);
        expect(saved.name, 'Ana M.');
        expect(saved.phone, '+1 555 7788');
        expect(authValue(await harness.repository.getCurrentUser())?.name, 'Ana M.');
      });
  
      test('Given the email of another account, When updated, '
          'Then userAlreadyExists is returned', () async {
        await harness.registerAna();
        final guest = authValue(await harness.repository.loginAsGuest());
  
        final result = await harness.repository.updateProfile(
          guest.copyWith(email: 'ana@example.com'),
        );
  
        expect(authFailure(result), const AuthFailure.userAlreadyExists());
      });
  
      test('Given an unknown account, When updated, '
          'Then userNotFound is returned', () async {
        final result = await harness.repository.updateProfile(
          const User(
            id: 'usr-missing',
            name: 'Ghost',
            email: 'ghost@example.com',
            phone: '+1 555 0100',
          ),
        );
  
        expect(authFailure(result), const AuthFailure.userNotFound());
      });
    });

    group('AuthRepository.loginAsGuest', () {
      test('When used, Then the throwaway guest profile is signed in', () async {
        final guest = authValue(await harness.repository.loginAsGuest());
  
        expect(guest.id, 'usr-guest');
        expect(guest.isGuest, isTrue);
        expect(authValue(await harness.repository.getCurrentUser())?.id, 'usr-guest');
      });
    });
}
