import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/bottom_action_bar.dart';
import 'package:hair_dryer_app/src/core/presentation/components/content_constraint.dart';
import 'package:hair_dryer_app/src/core/presentation/components/flow_header.dart';
import 'package:hair_dryer_app/src/core/presentation/components/primary_button.dart';
import 'package:hair_dryer_app/src/core/presentation/components/service_summary_bar.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/core/utils/formatters.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/appointments_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/booking_draft_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/date_strip.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/legend_dot.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/time_slot_sections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimePickerPage extends HookConsumerWidget {
  const new({super.key});

  static DateTime _firstOpenDay(DateTime from) {
    // Start from tomorrow to prevent past date bookings
    var day = DateTime(
      from.year,
      from.month,
      from.day,
    ).add(const Duration(days: 1));
    // Skip weekends and past dates
    for (var i = 0; i < 30; i++) {
      // Only accept weekdays (Monday=1 to Friday=5)
      if (day.weekday >= DateTime.monday && day.weekday <= DateTime.friday) {
        return day;
      }
      day = day.add(const Duration(days: 1));
    }
    // Fallback: return first valid date found
    return day;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final draft = ref.watch(bookingDraftProvider);
    final selectedDate = useState(draft.date ?? _firstOpenDay(DateTime.now()));
    final slots = ref.watch(dateSlotsProvider(selectedDate.value));

    useEffect(() {
      if (draft.date == null) {
        unawaited(
          Future.microtask(() {
            ref
                .read(bookingDraftProvider.notifier)
                .selectDate(selectedDate.value);
          }),
        );
      }
      return null;
    }, const []);

    final timeFormatted = draft.hasTime
        ? '${draft.hour!.toString().padLeft(2, '0')}:'
              '${draft.minute!.toString().padLeft(2, '0')}'
        : '';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentConstraint(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlowHeader(
                title: l10n.pickDateTime,
                step: 3,
                totalSteps: 4,
                onBack: () => context.canPop()
                    ? context.pop()
                    : context.go('/book/barber'),
              ),
              if (draft.service != null) ...[
                const SizedBox(height: AppSpace.xs),
                ServiceSummaryBar(service: draft.service!),
              ],
              const SizedBox(height: AppSpace.lg),
              DateStrip(
                selected: selectedDate.value,
                onSelect: (date) {
                  selectedDate.value = date;
                  ref.read(bookingDraftProvider.notifier).selectDate(date);
                },
              ),
              const SizedBox(height: AppSpace.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
                child: Row(
                  children: [
                    LegendDot(
                      color: context.accentStrong,
                      label: l10n.slotAvailable,
                    ),
                    const SizedBox(width: AppSpace.lg),
                    LegendDot(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      label: l10n.slotUnavailable,
                      dimmed: true,
                    ),
                    const Spacer(),
                    Text(
                      longDate(selectedDate.value, context),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpace.md),
              Expanded(
                child: TimeSlotSections(
                  slots: slots,
                  selectedDate: selectedDate.value,
                  selectedHour: draft.hour,
                  selectedMinute: draft.minute,
                  morningLabel: l10n.morningSlots,
                  afternoonLabel: l10n.afternoonSlots,
                  eveningLabel: l10n.eveningSlots,
                  emptyTodayLabel: l10n.noTimesLeftToday,
                  fullyBookedLabel: l10n.fullyBooked,
                  onSelect: (hour, minute) => ref
                      .read(bookingDraftProvider.notifier)
                      .selectTime(hour, minute),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: SizedBox(
          width: double.infinity,
          height: kTouchTarget + 4,
          child: PrimaryButton(
            onPressed: draft.hasTime
                ? () => unawaited(context.push('/book/review'))
                : null,
            child: Text(
              draft.hasTime
                  ? l10n.continueWithTime(timeFormatted)
                  : l10n.selectTime,
            ),
          ),
        ),
      ),
    );
  }
}
