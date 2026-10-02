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
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment_status.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/cancel_appointment_dialog.dart';

class AppointmentCard extends ConsumerWidget {
  const new({required this.appointment, required this.upcoming, super.key});

  final Appointment appointment;
  final bool upcoming;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final cancelled = appointment.status == AppointmentStatus.cancelled;

    return SoftCard(
      child: Opacity(
        opacity: cancelled ? 0.7 : 1,
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
            const SizedBox(height: AppSpace.md),
            Container(
              padding: const EdgeInsets.all(AppSpace.md),
              decoration: BoxDecoration(
                color: context.cardElevatedSurface,
                borderRadius: BorderRadius.circular(AppRadius.md + 2),
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
                    formatPrice2(appointment.price),
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (appointment.notes.isNotEmpty) ...[
              const SizedBox(height: AppSpace.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notes,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpace.sm),
                  Expanded(
                    child: Text(
                      appointment.localizedNotes(context),
                      style: textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpace.lg),
            if (upcoming && !cancelled)
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
              )
            else if (!upcoming && !cancelled)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref
                            .read(bookingDraftProvider.notifier)
                            .selectService(appointment.service);
                        unawaited(context.push('/book/barber'));
                      },
                      icon: const Icon(Icons.replay, size: 18),
                      label: Text(l10n.bookAgain),
                    ),
                  ),
                  const SizedBox(width: AppSpace.md),
                  Expanded(
                    child: TextButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(content: Text(l10n.ratingRecorded)),
                          ),
                      child: Text(l10n.rate),
                    ),
                  ),
                ],
              ),
          ],
        ),
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
