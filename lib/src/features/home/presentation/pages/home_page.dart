import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/content_constraint.dart';
import 'package:hair_dryer_app/src/core/presentation/components/section_header.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/appointments_notifier.dart';
import 'package:hair_dryer_app/src/features/home/presentation/components/barber_scroller.dart';
import 'package:hair_dryer_app/src/features/home/presentation/components/home_header.dart';
import 'package:hair_dryer_app/src/features/home/presentation/components/home_hero_card.dart';
import 'package:hair_dryer_app/src/features/home/presentation/components/next_appointment_card.dart';
import 'package:hair_dryer_app/src/features/home/presentation/components/offer_banner.dart';
import 'package:hair_dryer_app/src/features/home/presentation/components/service_scroller.dart';

class HomePage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final upcoming = ref.watch(upcomingAppointmentsProvider);
    final next = upcoming.isEmpty ? null : upcoming.first;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentConstraint(
          child: ListView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom + 80,
            ),
            children: [
              const HomeHeader(),
              const SizedBox(height: AppSpace.lg),
              HomeHeroCard(
                onBook: () => unawaited(context.push('/book/service')),
              ),
              if (next != null) ...[
                SectionHeader(title: l10n.nextAppointment),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
                  child: NextAppointmentCard(appointment: next),
                ),
              ],
              SectionHeader(title: l10n.services, actionLabel: l10n.seeAll),
              const ServiceScroller(),
              SectionHeader(title: l10n.topBarbers),
              const BarberScroller(),
              const SizedBox(height: AppSpace.xl),
              const OfferBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
