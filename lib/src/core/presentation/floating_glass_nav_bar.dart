import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Floating, animated navigation bar used by the mobile app shell.
class FloatingGlassNavBar extends StatelessWidget {
  const new({
    required this.selectedIndex,
    required this.destinations,
    required this.reduceMotion,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final List<NavigationDestination> destinations;
  final bool reduceMotion;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;
    final accent = context.accentStrong;
    final radius = BorderRadius.circular(AppRadius.xxl);
    final fill = (isDark ? AppColors.darkCard : AppColors.card)
        .withValues(alpha: isDark ? 0.72 : 0.78);
    final rim = Colors.white.withValues(alpha: isDark ? 0.10 : 0.70);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: reduceMotion
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
                  blurRadius: 28,
                  spreadRadius: -2,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: reduceMotion
              ? ImageFilter.blur()
              : ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: fill,
              borderRadius: radius,
              border: Border.all(color: rim),
            ),
            child: Row(
              children: [
                for (var index = 0; index < destinations.length; index++)
                  Expanded(
                    child: _NavTile(
                      destination: destinations[index],
                      selected: index == selectedIndex,
                      accent: accent,
                      reduceMotion: reduceMotion,
                      onTap: () => onDestinationSelected(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const new({
    required this.destination,
    required this.selected,
    required this.accent,
    required this.reduceMotion,
    required this.onTap,
  });

  final NavigationDestination destination;
  final bool selected;
  final Color accent;
  final bool reduceMotion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? accent
        : Theme.of(context).colorScheme.onSurfaceVariant;
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 220);

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: duration,
              curve: Curves.easeOutCubic,
              width: selected ? 54 : 42,
              height: 32,
              decoration: BoxDecoration(
                color: selected
                    ? accent.withValues(alpha: 0.16)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: selected
                    ? Border.all(color: accent.withValues(alpha: 0.30))
                    : null,
              ),
              child: AnimatedSwitcher(
                duration: duration,
                child: Icon(
                  key: ValueKey(selected),
                  selected
                      ? _iconData(destination.selectedIcon ?? destination.icon)
                      : _iconData(destination.icon),
                  color: color,
                  size: selected ? 24 : 22,
                ),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: duration,
              style: (Theme.of(context).textTheme.labelSmall ??
                      const TextStyle())
                  .copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 10,
                  ),
              child: Text(destination.label),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconData(Widget widget) => (widget as Icon).icon!;
}
