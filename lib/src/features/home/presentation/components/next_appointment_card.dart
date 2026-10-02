import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_avatar.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/presentation/components/status_chip.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/core/utils/formatters.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/appointments_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/booking_draft_notifier.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/cancel_appointment_dialog.dart';

class NextAppointmentCard extends ConsumerWidget {
  const new({required this.appointment, super.key});

  final Appointment appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return SoftCard(
      child: Column(
        children: [
          Row(
            children: [
              AppAvatar(
                avatarUrl: appointment.barber.avatarUrl,
                initials: appointment.barber.initials,
                color: Color(appointment.barber.accentColorValue),
                size: 46,
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.service.localizedName(context),
                      style: textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.withBarber(appointment.barber.name),
                      style: textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              StatusChip(status: appointment.status),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Container(
            padding: const EdgeInsets.all(AppSpace.md),
            decoration: BoxDecoration(
              color: context.mutedSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.event,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpace.xs + 2),
                Text(
                  dayLabel(appointment.start, context),
                  style: textTheme.labelMedium,
                ),
                const SizedBox(width: AppSpace.lg),
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpace.xs + 2),
                Text(
                  formatTimeOfDay(TimeOfDay.fromDateTime(appointment.start)),
                  style: textTheme.labelMedium,
                ),
                const Spacer(),
                Text(
                  formatPrice(appointment.price),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(bookingDraftProvider.notifier)
                      ..selectService(appointment.service)
                      ..selectBarber(appointment.barber);
                    unawaited(context.push('/book/time'));
                  },
                  child: Text(l10n.reschedule),
                ),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: TextButton(
                  onPressed: () => _confirmCancel(context, ref),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                  child: Text(l10n.cancel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    unawaited(
      CancelAppointmentModal.show(context, appointment, () {
        ref.read(appointmentsProvider.notifier).cancel(appointment.id);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.appointmentCancelled)));
      }),
    );
  }
}
