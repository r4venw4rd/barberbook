import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_shimmer.dart';
import 'package:hair_dryer_app/src/core/presentation/components/bottom_action_bar.dart';
import 'package:hair_dryer_app/src/core/presentation/components/content_constraint.dart';
import 'package:hair_dryer_app/src/core/presentation/components/flow_header.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/appointments_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/booking_draft_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/service_tile.dart';

class ServicePickerPage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final draft = ref.watch(bookingDraftProvider);
    final selectedId = draft.service?.id;
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentConstraint(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlowHeader(
                title: l10n.chooseService,
                step: 1,
                totalSteps: 4,
                onBack: () =>
                    context.canPop() ? context.pop() : context.go('/home'),
              ),
              Expanded(
                child: servicesAsync.when(
                  data: (services) => ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpace.lg,
                      AppSpace.xs,
                      AppSpace.lg,
                      AppSpace.xxl,
                    ),
                    itemCount: services.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpace.md),
                    itemBuilder: (context, index) {
                      final service = services[index];
                      final selected = service.id == selectedId;
                      return ServiceTile(
                        service: service,
                        selected: selected,
                        onTap: () => ref
                            .read(bookingDraftProvider.notifier)
                            .selectService(service),
                      );
                    },
                  ),
                  loading: () => const BookingServiceSkeleton(),
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
            onPressed: draft.hasService
                ? () => unawaited(context.push('/book/barber'))
                : null,
            child: Text(l10n.continueButton),
          ),
        ),
      ),
    );
  }
}
