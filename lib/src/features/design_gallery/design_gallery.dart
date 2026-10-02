// Design review harness: renders each screen side by side in light and dark
// so the presentation layer can be reviewed (and screenshotted) quickly.
//
// Run: flutter run -t lib/design_gallery.dart -d linux
// Pick: BB_SCREEN=home|service|barber|time|review|success|appointments|profile
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/appointments_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/booking_draft_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/pages/appointments_page.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/pages/booking_barber_page.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/pages/booking_review_page.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/pages/booking_service_page.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/pages/booking_success_page.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/pages/booking_time_page.dart';
import 'package:hair_dryer_app/src/features/home/presentation/pages/home_page.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/pages/profile_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _screens = <String>[
  'home',
  'service',
  'barber',
  'time',
  'review',
  'success',
  'appointments',
  'profile',
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final screen = Platform.environment['BB_SCREEN'] ?? 'home';
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DesignGallery(
          screen: _screens.contains(screen) ? screen : 'home',
        ),
      ),
    ),
  );
}

class DesignGallery extends HookConsumerWidget {
  const new({required this.screen, super.key});

  final String screen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      unawaited(
        Future.microtask(() async {
          final draft = ref.read(bookingDraftProvider.notifier);
          final services = await ref.read(servicesProvider.future);
          final barbers = await ref.read(barbersProvider.future);

          switch (screen) {
            case 'barber':
            case 'time':
              if (services.length > 1) draft.selectService(services[1]);
            case 'review':
              if (services.isNotEmpty && barbers.isNotEmpty) {
                final day = DateTime.now().add(const Duration(days: 2));
                draft
                  ..selectService(services[0])
                  ..selectBarber(barbers[0])
                  ..selectDate(DateTime(day.year, day.month, day.day))
                  ..selectTime(14, 30)
                  ..setNotes('Same length on top as last time.');
              }
            default:
              break;
          }
        }),
      );
      return null;
    }, const []);

    final screenWidget = switch (screen) {
      'service' => const ServicePickerPage(),
      'barber' => const BarberPickerPage(),
      'time' => const TimePickerPage(),
      'review' => const ReviewPage(),
      'success' => const BookingSuccessPage(),
      'appointments' => const AppointmentsPage(),
      'profile' => const ProfilePage(),
      _ => const HomePage(),
    };

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpace.md),
              child: Text(
                'BarberBook — $screen',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PhoneFrame(
                    label: 'Light',
                    mode: ThemeMode.light,
                    child: screenWidget,
                  ),
                  const SizedBox(width: AppSpace.xl),
                  _PhoneFrame(
                    label: 'Dark',
                    mode: ThemeMode.dark,
                    child: screenWidget,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  const new({required this.label, required this.mode, required this.child});

  final String label;
  final ThemeMode mode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpace.sm),
        Container(
          width: 390,
          height: 844,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(390, 844)),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: mode,
                home: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
