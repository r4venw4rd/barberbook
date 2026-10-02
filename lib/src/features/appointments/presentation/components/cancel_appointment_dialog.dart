import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_avatar.dart';
import 'package:hair_dryer_app/src/core/presentation/components/primary_button.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/core/utils/formatters.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment.dart';

/// Modern modal bottom sheet for appointment cancellation.
class CancelAppointmentModal extends StatelessWidget {
  /// Creates the cancel appointment modal.
  const new({required this.appointment, required this.onConfirm, super.key});

  /// The appointment to be cancelled.
  final Appointment appointment;

  /// Callback when user confirms cancellation.
  final VoidCallback onConfirm;

  /// Shows the cancel confirmation bottom sheet.
  static Future<void> show(
    BuildContext context,
    Appointment appointment,
    VoidCallback onConfirm,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => CancelAppointmentModal(
        appointment: appointment,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: context.cardSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl + 4),
        ),
        border: Border.all(color: context.borderSurface),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpace.xl,
        AppSpace.md,
        AppSpace.xl,
        AppSpace.xxl,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.borderSurface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.dangerText.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.event_busy_outlined,
                    color: context.dangerText,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.cancelVisitTitle,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.cancelVisitSubtitle,
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.lg),
            Container(
              padding: const EdgeInsets.all(AppSpace.md),
              decoration: BoxDecoration(
                color: context.mutedSurface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: context.borderSurface),
              ),
              child: Row(
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
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${dayLabel(appointment.start, context)} · '
                          '${formatTimeOfDay(TimeOfDay.fromDateTime(appointment.start))} · ${l10n.withBarber(appointment.barber.name)}',
                          style: textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.xl),
            SizedBox(
              height: kTouchTarget,
              child: PrimaryButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.keepAppointment),
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            SizedBox(
              height: kTouchTarget,
              child: TextButton(
                onPressed: onConfirm,
                style: TextButton.styleFrom(
                  foregroundColor: context.dangerText,
                ),
                child: Text(l10n.confirmCancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
