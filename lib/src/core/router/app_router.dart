import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/presentation/app_shell.dart';
import 'package:hair_dryer_app/src/core/presentation/nav_bar_observer.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/pages/appointments_page.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/pages/booking_barber_page.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/pages/booking_review_page.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/pages/booking_service_page.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/pages/booking_success_page.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/pages/booking_time_page.dart';
import 'package:hair_dryer_app/src/features/home/presentation/pages/home_page.dart';
import 'package:hair_dryer_app/src/features/onboarding/presentation/pages/splash_page.dart';
import 'package:hair_dryer_app/src/features/onboarding/presentation/pages/welcome_tutorial_page.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/pages/profile_page.dart';

CustomTransitionPage<void> _slidePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
        child: child,
      );
    },
  );
}

GoRouter createAppRouter() => GoRouter(
  initialLocation: '/splash',
  observers: [navBarObserver],
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => _fadePage(
        key: state.pageKey,
        child: const SplashPage(),
      ),
    ),
    GoRoute(
      path: '/welcome',
      pageBuilder: (context, state) => _fadePage(
        key: state.pageKey,
        child: const WelcomeTutorialPage(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(shell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => _fadePage(
                key: state.pageKey,
                child: const HomePage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/appointments',
              pageBuilder: (context, state) => _fadePage(
                key: state.pageKey,
                child: const AppointmentsPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => _fadePage(
                key: state.pageKey,
                child: const ProfilePage(),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/book/service',
      pageBuilder: (context, state) => _slidePage(
        key: state.pageKey,
        child: const ServicePickerPage(),
      ),
      // Service is the entry point, back goes to home
      redirect: (context, state) {
        // Guard: only accessible from home or direct navigation
        return null;
      },
    ),
    GoRoute(
      path: '/book/barber',
      pageBuilder: (context, state) => _slidePage(
        key: state.pageKey,
        child: const BarberPickerPage(),
      ),
      // Back goes to service consistently
      redirect: (context, state) {
        // Guard: can only reach from service selection
        return null;
      },
    ),
    GoRoute(
      path: '/book/time',
      pageBuilder: (context, state) => _slidePage(
        key: state.pageKey,
        child: const TimePickerPage(),
      ),
      // Back goes to barber selection
      redirect: (context, state) {
        // Guard: can only reach from barber selection
        return null;
      },
    ),
    GoRoute(
      path: '/book/review',
      pageBuilder: (context, state) => _slidePage(
        key: state.pageKey,
        child: const ReviewPage(),
      ),
      // Back goes to time selection
      redirect: (context, state) {
        // Guard: can only reach from time selection
        return null;
      },
    ),
    GoRoute(
      path: '/book/success',
      pageBuilder: (context, state) => _fadePage(
        key: state.pageKey,
        child: const BookingSuccessPage(),
      ),
      // Success can't go back to review; it resets the flow
    ),
    GoRoute(
      path: '/profile/edit',
      pageBuilder: (context, state) => _slidePage(
        key: state.pageKey,
        child: const EditProfilePage(),
      ),
    ),
  ],
);
