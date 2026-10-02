import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/content_constraint.dart';
import 'package:hair_dryer_app/src/core/presentation/components/primary_button.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/appointments_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/ticket_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookingSuccessPage extends HookConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showCheck = useState(false);
    final upcoming = ref.watch(upcomingAppointmentsProvider);
    final appointment = upcoming.isEmpty ? null : upcoming.first;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    useEffect(() {
      if (MediaQuery.disableAnimationsOf(context)) {
        showCheck.value = true;
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCheck.value = true;
          unawaited(HapticFeedback.mediumImpact());
        });
      }
      return null;
    }, const []);

    if (appointment == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: PrimaryButton(
              onPressed: () => context.go('/home'),
              child: Text(l10n.backToHome),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ContentConstraint(
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Column(
              children: [
                const Spacer(),
                AnimatedScale(
                  scale: showCheck.value ? 1 : 0.4,
                  duration: const Duration(milliseconds: 380),
                  curve: Curves.elasticOut,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: context.successSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.successText, width: 2),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 48,
                      color: context.successText,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.lg),
                Text(
                  l10n.bookingSuccessTitle,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpace.xs),
                Text(
                  l10n.bookingSuccessSubtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpace.xl),
                TicketCard(
                  service: appointment.service,
                  barber: appointment.barber,
                  date: appointment.start,
                  totalPrice: appointment.price,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: kTouchTarget + 4,
                  child: PrimaryButton(
                    onPressed: () => context.go('/appointments'),
                    child: Text(l10n.viewMyAppointments),
                  ),
                ),
                const SizedBox(height: AppSpace.sm),
                SizedBox(
                  width: double.infinity,
                  height: kTouchTarget + 4,
                  child: OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.calendarAdded),
                      ),
                    ),
                    icon: const Icon(Icons.event_available, size: 20),
                    label: Text(l10n.addToCalendar),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/home'),
                  child: Text(l10n.backToHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
