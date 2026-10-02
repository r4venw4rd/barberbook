import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_shimmer.dart';
import 'package:hair_dryer_app/src/core/presentation/components/bottom_action_bar.dart';
import 'package:hair_dryer_app/src/core/presentation/components/content_constraint.dart';
import 'package:hair_dryer_app/src/core/presentation/components/flow_header.dart';
import 'package:hair_dryer_app/src/core/presentation/components/service_summary_bar.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/appointments_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/booking_draft_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/barber_tile.dart';

class BarberPickerPage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final draft = ref.watch(bookingDraftProvider);
    final selectedId = draft.barber?.id;
    final barbersAsync = ref.watch(barbersProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentConstraint(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlowHeader(
                title: l10n.pickBarber,
                step: 2,
                totalSteps: 4,
                onBack: () => context.canPop()
                    ? context.pop()
                    : context.go('/book/service'),
              ),
              if (draft.service != null) ...[
                const SizedBox(height: AppSpace.xs),
                ServiceSummaryBar(service: draft.service!),
              ],
              const SizedBox(height: AppSpace.lg),
              Expanded(
                child: barbersAsync.when(
                  data: (barbers) => ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpace.lg,
                      AppSpace.xs,
                      AppSpace.lg,
                      AppSpace.xxl,
                    ),
                    itemCount: barbers.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpace.md),
                    itemBuilder: (context, index) {
                      final barber = barbers[index];
                      return BarberTile(
                        barber: barber,
                        selected: barber.id == selectedId,
                        onTap: () => ref
                            .read(bookingDraftProvider.notifier)
                            .selectBarber(barber),
                      );
                    },
                  ),
                  loading: () => const BookingBarberSkeleton(),
                  error: (e, _) => Center(child: Text(e.toString())),
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
          child: FilledButton(
            onPressed: draft.hasBarber
                ? () => unawaited(context.push('/book/time'))
                : null,
            child: Text(l10n.continueButton),
          ),
        ),
      ),
    );
  }
}
