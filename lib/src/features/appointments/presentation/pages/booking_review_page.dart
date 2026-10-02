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
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment_status.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/booking_detail_card.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/review_notes_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReviewPage extends HookConsumerWidget {
  const new({super.key});

  static const _bookingFee = 2.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final draft = ref.watch(bookingDraftProvider);
    final textTheme = Theme.of(context).textTheme;
    final notesController = useTextEditingController(text: draft.notes);
    final isSubmitting = useState(false);

    if (!draft.isComplete) {
      return _IncompleteBookingView(
        onStartOver: () => context.go('/book/service'),
      );
    }

    final service = draft.service!;
    final barber = draft.barber!;
    final start = draft.start!;
    final total = service.price + _bookingFee;

    Future<void> confirm() async {
      if (!draft.isComplete || isSubmitting.value) return;
      isSubmitting.value = true;
      await Future<void>.delayed(const Duration(milliseconds: 850));
      ref.read(appointmentsProvider.notifier).add(
            Appointment(
              id: 'apt-${start.microsecondsSinceEpoch}',
              service: service,
              barber: barber,
              start: start,
              notes: draft.notes,
              status: AppointmentStatus.confirmed,
              price: total,
            ),
          );
      ref.read(bookingDraftProvider.notifier).reset();
      if (!context.mounted) return;
      context.go('/book/success');
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentConstraint(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlowHeader(
                title: l10n.reviewConfirm,
                step: 4,
                totalSteps: 4,
                onBack: () => context.canPop()
                    ? context.pop()
                    : context.go('/book/time'),
              ),
              const SizedBox(height: AppSpace.xs),
              ServiceSummaryBar(service: service),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpace.lg),
                  children: [
                    BookingDetailCard(
                      service: service,
                      barber: barber,
                      start: start,
                      bookingFee: _bookingFee,
                    ),
                    const SizedBox(height: AppSpace.xl),
                    ReviewNotesCard(
                      controller: notesController,
                      onChanged:
                          ref.read(bookingDraftProvider.notifier).setNotes,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.total, style: textTheme.bodySmall),
            Text(
              formatPrice2(total),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: kTouchTarget + 4,
          child: PrimaryButton(
            onPressed: isSubmitting.value ? null : confirm,
            child: isSubmitting.value
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
                  )
                : Text(l10n.confirmBooking),
          ),
        ),
      ),
    );
  }
}

class _IncompleteBookingView extends StatelessWidget {
  const new({required this.onStartOver});

  final VoidCallback onStartOver;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.event_busy_outlined, size: 48),
              const SizedBox(height: AppSpace.md),
              Text(l10n.incompleteBooking),
              const SizedBox(height: AppSpace.xl),
              PrimaryButton(
                onPressed: onStartOver,
                child: Text(l10n.startOver),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
