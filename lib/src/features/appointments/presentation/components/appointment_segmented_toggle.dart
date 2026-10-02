import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Two-segment toggle switcher for upcoming and past appointments.
class AppointmentSegmentedToggle extends StatelessWidget {
  const new({
    required this.upLabel,
    required this.downLabel,
    required this.showUp,
    required this.onChanged,
    super.key,
  });

  final String upLabel;
  final String downLabel;
  final bool showUp;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    Widget segment({
      required String label,
      required bool isSelected,
      required bool value,
    }) {
      return Expanded(
        child: Semantics(
          button: true,
          selected: isSelected,
          label: label,
          excludeSemantics: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: isSelected ? context.primaryGradient : null,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: context.primaryShadow.withValues(alpha: 0.32),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                label,
                style: textTheme.titleSmall?.copyWith(
                  color: isSelected ? AppColors.onPrimary : onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.mutedSurface,
        borderRadius: BorderRadius.circular(AppRadius.md + 2),
        border: Border.all(color: context.borderSurface),
      ),
      child: Row(
        children: [
          segment(label: upLabel, isSelected: showUp, value: true),
          segment(label: downLabel, isSelected: !showUp, value: false),
        ],
      ),
    );
  }
}
