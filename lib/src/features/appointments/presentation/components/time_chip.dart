import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/time_slot.dart';

class TimeChip extends StatelessWidget {
  const new({
    required this.slot,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
    super.key,
  });

  final TimeSlot slot;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final unavailable = slot.unavailable;
    final suffix = slot.booked
        ? l10n.slotFull
        : slot.passed
        ? l10n.slotPast
        : '';

    final background = isSelected
        ? activeColor
        : unavailable
        ? (context.isDarkTheme
              ? const Color(0xFF161F33)
              : const Color(0xFFF1F5F9))
        : context.cardSurface;
    final foreground = isSelected
        ? Colors.white
        : unavailable
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : Theme.of(context).colorScheme.onSurface;

    final statusLabel = slot.booked
        ? l10n.timeSlotBooked
        : l10n.timeSlotPassed;
    final selectedSuffix = isSelected ? ', ${l10n.timeSlotSelected}' : '';
    final semanticLabel = unavailable
        ? '${slot.label}, $statusLabel'
        : '${slot.label}$selectedSuffix';

    return Semantics(
      button: !unavailable,
      selected: isSelected,
      enabled: !unavailable,
      label: semanticLabel,
      excludeSemantics: true,
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 104,
          height: kTouchTarget,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isSelected
                  ? activeColor
                  : unavailable
                  ? Colors.transparent
                  : context.borderSurface,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap != null
                  ? () {
                      unawaited(HapticFeedback.selectionClick());
                      onTap!();
                    }
                  : null,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Center(
                child: Text(
                  '${slot.label}$suffix',
                  style: textTheme.titleSmall?.copyWith(
                    color: foreground,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    decoration: unavailable ? TextDecoration.lineThrough : null,
                    decorationColor: unavailable ? foreground : null,
                    fontSize: unavailable ? 13 : 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
