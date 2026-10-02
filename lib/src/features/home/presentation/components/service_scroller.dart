import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_shimmer.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/appointments_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/booking_draft_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/service_icon.dart';

class ServiceScroller extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final active = context.accentStrong;
    final servicesAsync = ref.watch(servicesProvider);

    return SizedBox(
      height: 158,
      child: servicesAsync.when(
        data: (services) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          itemCount: services.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpace.md),
          itemBuilder: (context, index) {
            final service = services[index];
            return SizedBox(
              width: 160,
              child: SoftCard(
                radius: AppRadius.xl,
                onTap: () {
                  ref
                      .read(bookingDraftProvider.notifier)
                      .selectService(service);
                  unawaited(context.push('/book/barber'));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container with gold ring on selected state
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            active.withValues(alpha: 0.18),
                            active.withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.md + 2),
                        border: Border.all(
                          color: active.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Icon(
                        serviceIcon(service),
                        color: active,
                        size: 22,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      service.localizedName(context),
                      style: textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          service.priceLabel,
                          style: textTheme.labelSmall?.copyWith(
                            color: active,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            ' · ${service.localizedDuration(context)}',
                            style: textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
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
        loading: () => const ServiceScrollerSkeleton(),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
