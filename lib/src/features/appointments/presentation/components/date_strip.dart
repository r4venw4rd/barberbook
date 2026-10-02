import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/core/utils/formatters.dart';

/// Horizontal calendar strip allowing the user to select an appointment date.
class DateStrip extends StatelessWidget {
  const new({required this.selected, required this.onSelect, super.key});

  final DateTime selected;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final activeColor = context.accentStrong;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final days = List.generate(14, (i) => today.add(Duration(days: i)));

    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpace.sm + 2),
        itemBuilder: (context, index) {
          final day = days[index];
          final closed = day.weekday == DateTime.sunday;
          final isSelected =
              !closed &&
              day.year == selected.year &&
              day.month == selected.month &&
              day.day == selected.day;
          final isToday = day == today;
          final fg = closed
              ? Theme.of(context).colorScheme.onSurfaceVariant
              : isSelected
              ? AppColors.onPrimary
              : Theme.of(context).colorScheme.onSurface;

          return Semantics(
            button: !closed,
            selected: isSelected,
            label: closed
                ? '${longDate(day, context)}, ${l10n.closed}'
                : '${longDate(day, context)}'
                    '${isToday ? ', ${l10n.today.toLowerCase()}' : ''}',
            excludeSemantics: true,
            child: Tooltip(
              message: closed ? l10n.closedOnSundays : longDate(day, context),
              child: GestureDetector(
                key: ValueKey('day-$index'),
                onTap: closed ? null : () => onSelect(day),
                behavior: HitTestBehavior.opaque,
                child: AnimatedScale(
                  scale: isSelected ? 1.04 : 1,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 62,
                    decoration: BoxDecoration(
                      gradient: isSelected ? context.primaryGradient : null,
                      color: isSelected ? null : AppColors.clear,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.clear
                            : isToday
                            ? activeColor
                            : context.borderSurface,
                        width: isToday && !isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: context.primaryShadow.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Opacity(
                      opacity: closed ? 0.4 : 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weekdayShort(day, context),
                            style: textTheme.labelSmall?.copyWith(color: fg),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${day.day}',
                            style: textTheme.titleLarge?.copyWith(
                              color: fg,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            monthLabel(day, context),
                            style: textTheme.labelSmall?.copyWith(color: fg),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
