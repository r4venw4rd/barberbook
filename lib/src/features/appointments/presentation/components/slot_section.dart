import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/time_slot.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/time_chip.dart';

class SlotSection extends StatelessWidget {
  const new({
    required this.title,
    required this.slots,
    required this.selectedHour,
    required this.selectedMinute,
    required this.onSelect,
    super.key,
    this.icon,
  });

  final String title;
  final List<TimeSlot> slots;
  final int? selectedHour;
  final int? selectedMinute;
  final void Function(int hour, int minute) onSelect;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final activeColor = context.accentStrong;
    final availableCount = slots.where((s) => !s.unavailable).length;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppSpace.xs + 2),
              ],
              Text(title, style: textTheme.titleSmall),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: context.mutedSurface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: context.borderSurface),
                ),
                child: Text(
                  l10n.availableCount(availableCount),
                  style: textTheme.labelSmall?.copyWith(fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.md,
            children: [
              for (final slot in slots)
                TimeChip(
                  slot: slot,
                  isSelected:
                      selectedHour == slot.hour &&
                      selectedMinute == slot.minute,
                  activeColor: activeColor,
                  onTap: slot.unavailable
                      ? null
                      : () => onSelect(slot.hour, slot.minute),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
