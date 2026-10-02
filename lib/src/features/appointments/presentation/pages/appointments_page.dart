import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/content_constraint.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/appointments_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/appointment_card.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/appointment_empty_state.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/appointment_segmented_toggle.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppointmentsPage extends HookConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showUpcoming = useState(true);
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final upcoming = ref.watch(upcomingAppointmentsProvider);
    final past = ref.watch(pastAppointmentsProvider);
    final items = showUpcoming.value ? upcoming : past;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentConstraint(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.lg,
                  AppSpace.md,
                  AppSpace.lg,
                  AppSpace.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.yourAppointments, style: textTheme.headlineSmall),
                    const SizedBox(height: AppSpace.xs),
                    Text(
                      l10n.appointmentStats(upcoming.length, past.length),
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
                child: AppointmentSegmentedToggle(
                  upLabel: l10n.upcoming,
                  downLabel: l10n.past,
                  showUp: showUpcoming.value,
                  onChanged: (value) => showUpcoming.value = value,
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: items.isEmpty
                      ? AppointmentEmptyState(
                          key: ValueKey('empty-${showUpcoming.value}'),
                          upcoming: showUpcoming.value,
                        )
                      : ListView.separated(
                          key: ValueKey('list-${showUpcoming.value}'),
                          padding: EdgeInsets.fromLTRB(
                            AppSpace.lg,
                            AppSpace.xs,
                            AppSpace.lg,
                            MediaQuery.paddingOf(context).bottom + 80,
                          ),
                          itemCount: items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpace.md),
                          itemBuilder: (context, index) => AppointmentCard(
                            appointment: items[index],
                            upcoming: showUpcoming.value,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
