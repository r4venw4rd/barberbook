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

    group('AuthRepository session', () {
      test('Given a signed-in user, When logged out, '
          'Then the session record is removed', () async {
        await harness.registerAna();
  
        authValue(await harness.repository.logout());
  
        expect(authValue(await harness.repository.getCurrentUser()), isNull);
        expect(harness.database.session.isEmpty, isTrue);
      });
  
      test('Given a stored session, When another repository opens the database, '
          'Then the session survives', () async {
        final registered = await harness.registerAna();
        final reopened = AuthRepository(
          AuthLocalService(database),
          const PasswordHasher(iterations: 1),
        );
  
        final result = await reopened.getCurrentUser();
  
        expect(authValue(result)?.id, registered.id);
      });
  
      test('Given an expired session, When restored, '
          'Then the user is null and the session is cleared', () async {
        await harness.registerAna();
        final raw = Map<String, dynamic>.from(
          harness.database.session.get(AppDatabase.sessionKey)!,
        );
        raw['expiresAt'] = DateTime.now()
            .toUtc()
            .subtract(const Duration(days: 1))
            .toIso8601String();
        await harness.database.session.put(AppDatabase.sessionKey, raw);
  
        expect(authValue(await harness.repository.getCurrentUser()), isNull);
        expect(harness.database.session.isEmpty, isTrue);
      });
  
      test('Given a session pointing at a deleted account, When restored, '
          'Then the user is null and the session is cleared', () async {
        final registered = await harness.registerAna();
        await harness.database.users.delete(registered.id);
  
        expect(authValue(await harness.repository.getCurrentUser()), isNull);
        expect(harness.database.session.isEmpty, isTrue);
      });
    });
}
