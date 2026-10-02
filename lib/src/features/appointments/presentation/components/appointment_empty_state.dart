import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/bouncing_button.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

class AppointmentEmptyState extends StatelessWidget {
  const new({required this.upcoming, super.key});

  final bool upcoming;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: context.mutedSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                upcoming ? Icons.event_available_outlined : Icons.history,
                size: 34,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            Text(
              upcoming ? l10n.noUpcomingVisits : l10n.noPastVisits,
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpace.xs),
            Text(
              upcoming ? l10n.noUpcomingVisitsSub : l10n.noPastVisitsSub,
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (upcoming) ...[
              const SizedBox(height: AppSpace.xl),
              BouncingWrapper(
                onTap: () => unawaited(context.push('/book/service')),
                child: FilledButton(
                  onPressed: () => unawaited(context.push('/book/service')),
                  child: Text(l10n.bookAppointment),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
