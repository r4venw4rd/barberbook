import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/services/password_hasher.dart';

void main() {
  // PBKDF2-HMAC-SHA256 reference vector: password "password", salt "salt",
  // c=1, dkLen=32.
  const referenceVector =
      r'pbkdf2_sha256$1$c2FsdA==$'
      'Eg+2z/z4syxD5yJSVsT4N6hlSMkszDVICAWYfLcL4Xs=';

  group('PasswordHasher.hash', () {
    test('Given a password, When hashed twice, '
        'Then both results verify but never match each other', () {
      const hasher = PasswordHasher();

      final first = hasher.hash('Sunset!Barber9');
      final second = hasher.hash('Sunset!Barber9');

      expect(hasher.verify('Sunset!Barber9', first), isTrue);
      expect(hasher.verify('Sunset!Barber9', second), isTrue);
      expect(first, isNot(second));
      final parts = first.split(r'$');
      expect(parts[0], 'pbkdf2_sha256');
      expect(parts[1], '${hasher.iterations}');
    });
  });

  group('PasswordHasher.verify', () {
    test('Given the reference vector, When the correct password is verified, '
        'Then verification succeeds', () {
      const hasher = PasswordHasher(iterations: 1);

      expect(hasher.verify('password', referenceVector), isTrue);
    });

    test('Given a wrong password, When verified against a valid hash, '
        'Then verification fails', () {
      const hasher = PasswordHasher(iterations: 1);
      final encoded = hasher.hash('CorrectHorse1');

      expect(hasher.verify('correcthorse1', encoded), isFalse);
      expect(hasher.verify('', encoded), isFalse);
    });

    test('Given a malformed or tampered hash, When verified, '
        'Then verification fails without throwing', () {
      const hasher = PasswordHasher(iterations: 1);

      expect(hasher.verify('password', 'not-a-hash'), isFalse);
      expect(hasher.verify('password', r'bcrypt$10$abc$def'), isFalse);
      expect(hasher.verify('password', r'pbkdf2_sha256$x$y$z'), isFalse);
      expect(
        hasher.verify('password', referenceVector.substring(0, 30)),
        isFalse,
      );
    });
  });
}
