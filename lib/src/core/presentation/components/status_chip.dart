import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment_status.dart';

/// Refined status badge with subtle indicator dot and clean typography.
class StatusChip extends StatelessWidget {
  /// Creates a status chip.
  const new({required this.status, super.key});

  /// Appointment status to render.
  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, dotColor) = switch (status) {
      AppointmentStatus.confirmed => (
        l10n.statusConfirmed,
        context.successText,
      ),
      AppointmentStatus.pending => (l10n.statusPending, context.warningText),
      AppointmentStatus.completed => (
        l10n.statusCompleted,
        Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      AppointmentStatus.cancelled => (l10n.statusCancelled, context.dangerText),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.sm + 2,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: context.mutedSurface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: context.borderSurface),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
