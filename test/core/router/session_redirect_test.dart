import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/core/router/app_router.dart';
import 'package:hair_dryer_app/src/features/auth/domain/entities/user.dart';

void main() {
  const user = User(
    id: 'usr-1',
    name: 'Ana Diaz',
    email: 'ana@example.com',
    phone: '+1 555 0100',
  );
  const signedIn = AsyncData<User?>(user);
  const signedOut = AsyncData<User?>(null);
  const loading = AsyncLoading<User?>();

  test('Given a signed-in session, When visiting the sign-in route, '
      'Then the visitor is sent home', () {
    expect(sessionRedirect(signedIn, '/auth'), '/home');
  });

  test('Given a signed-in session, When visiting a protected route, '
      'Then navigation continues unchanged', () {
    expect(sessionRedirect(signedIn, '/home'), isNull);
    expect(sessionRedirect(signedIn, '/book/service'), isNull);
    expect(sessionRedirect(signedIn, '/profile/edit'), isNull);
  });

  test('Given no session, When visiting a protected route, '
      'Then the visitor is sent to sign in', () {
    expect(sessionRedirect(signedOut, '/home'), '/auth');
    expect(sessionRedirect(signedOut, '/appointments'), '/auth');
    expect(sessionRedirect(signedOut, '/profile/edit'), '/auth');
  });

  test('Given no session, When visiting public routes, '
      'Then navigation continues unchanged', () {
    expect(sessionRedirect(signedOut, '/auth'), isNull);
    expect(sessionRedirect(signedOut, '/splash'), isNull);
    expect(sessionRedirect(signedOut, '/welcome'), isNull);
    expect(sessionRedirect(signedOut, '/'), isNull);
  });

  test('Given a session still loading, When visiting any route, '
      'Then the splash screen keeps deciding', () {
    expect(sessionRedirect(loading, '/splash'), isNull);
    expect(sessionRedirect(loading, '/home'), isNull);
    expect(sessionRedirect(loading, '/auth'), isNull);
  });
}
