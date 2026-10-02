import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_avatar.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_shimmer.dart';
import 'package:hair_dryer_app/src/core/presentation/components/rating_badge.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/appointments_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/booking_draft_notifier.dart';

class BarberScroller extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final barbersAsync = ref.watch(barbersProvider);

    return SizedBox(
      height: 186,
      child: barbersAsync.when(
        data: (barbers) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          itemCount: barbers.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpace.md),
          itemBuilder: (context, index) {
            final barber = barbers[index];
            final isAvailable = barber.isAvailableToday;
            final availColor = isAvailable
                ? context.successText
                : context.warningText;

            return SizedBox(
              width: 176,
              child: SoftCard(
                onTap: () {
                  ref.read(bookingDraftProvider.notifier).selectBarber(barber);
                  unawaited(context.push('/book/barber'));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar + availability dot
                    Center(
                      child: AppAvatar(
                        avatarUrl: barber.avatarUrl,
                        initials: barber.initials,
                        color: Color(barber.accentColorValue),
                        size: 58,
                        showBadge: true,
                        badgeColor: availColor,
                      ),
                    ),
                    const SizedBox(height: AppSpace.sm + 2),
                    Text(
                      barber.name,
                      style: textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      barber.localizedSpecialty(context),
                      style: textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        RatingBadge(rating: barber.rating),
                        const Spacer(),
                        // Availability pill
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpace.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: availColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                            ),
                            child: Text(
                              isAvailable ? l10n.today : l10n.tomorrow,
                              style: textTheme.labelSmall?.copyWith(
                                color: availColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const BarberScrollerSkeleton(),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
