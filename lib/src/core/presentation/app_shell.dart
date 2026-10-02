import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_background_pattern.dart';
import 'package:hair_dryer_app/src/core/presentation/nav_bar_observer.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/core/theme/breakpoints.dart';

class AppShell extends StatelessWidget {
  const new({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return _DesktopShell(shell: shell);
    }
    if (context.isTablet) {
      return _TabletShell(shell: shell);
    }
    return _MobileShell(shell: shell);
  }
}

// ---------------------------------------------------------------------------
// Mobile — floating pill nav bar
// ---------------------------------------------------------------------------

class _MobileShell extends StatelessWidget {
  const new({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = context.isDarkTheme;
    final accent = context.accentStrong;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    // Floating nav sits above safe area with a small gap
    const navHeight = 64.0;
    const navHMargin = 20.0; // horizontal inset from screen edges
    const navBGap = 10.0;    // gap above safe area (or screen bottom)
    final navBottomOffset = bottomPad + navBGap;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Page content with background pattern
          AppBackgroundPattern(child: shell),
          // Floating glass nav bar — animates down when a modal is shown
          ValueListenableBuilder<bool>(
            valueListenable: navBarObserver.isNavBarVisible,
            builder: (context, isVisible, child) {
              return AnimatedPositioned(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 320),
                curve: isVisible
                    ? Curves.easeOutBack   // spring back up
                    : Curves.easeInCubic,  // quick dive down
                left: navHMargin,
                right: navHMargin,
                bottom: isVisible
                    ? navBottomOffset
                    : -(navHeight + navBottomOffset + 12),
                height: navHeight,
                child: AnimatedOpacity(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 200),
                  opacity: isVisible ? 1.0 : 0.0,
                  child: child!,
                ),
              );
            },
            child: _FloatingGlassNavBar(
              selectedIndex: shell.currentIndex,
              isDark: isDark,
              accent: accent,
              reduceMotion: reduceMotion,
              onDestinationSelected: (index) => shell.goBranch(
                index,
                initialLocation: index == shell.currentIndex,
              ),
              destinations: [
                _NavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: l10n.navHome,
                ),
                _NavItem(
                  icon: Icons.event_note_outlined,
                  selectedIcon: Icons.event_note_rounded,
                  label: l10n.navAppointments,
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_rounded,
                  label: l10n.navProfile,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Floating glass nav bar (pill shape, detached from screen edge)
// ---------------------------------------------------------------------------

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _FloatingGlassNavBar extends StatelessWidget {
  const _FloatingGlassNavBar({
    required this.selectedIndex,
    required this.isDark,
    required this.accent,
    required this.reduceMotion,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final bool isDark;
  final Color accent;
  final bool reduceMotion;
  final ValueChanged<int> onDestinationSelected;
  final List<_NavItem> destinations;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Glass fill — dark mode needs slightly more opacity for legibility
    final glassFill = isDark
        ? AppColors.darkCard.withValues(alpha: 0.72)
        : AppColors.card.withValues(alpha: 0.78);

    // Outer border — 1px glass rim
    final glassRimColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.white.withValues(alpha: 0.70);

    const radius = Radius.circular(AppRadius.xxl);
    final borderRadius = BorderRadius.all(radius);

    return DecoratedBox(
      // Outer shadow so the pill "floats" off the background
      decoration: BoxDecoration(
        borderRadius: borderRadius,
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
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: reduceMotion
              ? ImageFilter.blur()
              : ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: glassFill,
              borderRadius: borderRadius,
              border: Border.all(color: glassRimColor, width: 1),
            ),
            child: Row(
              children: [
                for (var i = 0; i < destinations.length; i++)
                  Expanded(
                    child: _NavTile(
                      item: destinations[i],
                      isSelected: i == selectedIndex,
                      accent: accent,
                      textTheme: textTheme,
                      reduceMotion: reduceMotion,
                      onTap: () => onDestinationSelected(i),
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
  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.accent,
    required this.textTheme,
    required this.reduceMotion,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final Color accent;
  final TextTheme textTheme;
  final bool reduceMotion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unselectedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final resolvedColor = isSelected ? accent : unselectedColor;
    final dur = reduceMotion ? Duration.zero : const Duration(milliseconds: 220);

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated pill capsule behind icon
            AnimatedContainer(
              duration: dur,
              curve: Curves.easeOutCubic,
              width: isSelected ? 54 : 42,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? accent.withValues(alpha: 0.16)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: isSelected
                    ? Border.all(
                        color: accent.withValues(alpha: 0.30),
                        width: 0.75,
                      )
                    : null,
              ),
              child: AnimatedSwitcher(
                duration: dur,
                child: Icon(
                  key: ValueKey(isSelected),
                  isSelected ? item.selectedIcon : item.icon,
                  color: resolvedColor,
                  size: isSelected ? 24 : 22,
                ),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: dur,
              style: (textTheme.labelSmall ?? const TextStyle()).copyWith(
                color: resolvedColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 10,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tablet
// ---------------------------------------------------------------------------

class _TabletShell extends StatelessWidget {
  const new({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: (index) => shell.goBranch(
              index,
              initialLocation: index == shell.currentIndex,
            ),
            labelType: NavigationRailLabelType.none,
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: Text(l10n.navHome),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.event_note_outlined),
                selectedIcon: const Icon(Icons.event_note_rounded),
                label: Text(l10n.navAppointments),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.person_outline_rounded),
                selectedIcon: const Icon(Icons.person_rounded),
                label: Text(l10n.navProfile),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: AppBackgroundPattern(child: shell),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop
// ---------------------------------------------------------------------------

class _DesktopShell extends StatelessWidget {
  const new({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: (index) => shell.goBranch(
              index,
              initialLocation: index == shell.currentIndex,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 16, 10),
                child: Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              NavigationDrawerDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: Text(l10n.navHome),
              ),
              NavigationDrawerDestination(
                icon: const Icon(Icons.event_note_outlined),
                selectedIcon: const Icon(Icons.event_note_rounded),
                label: Text(l10n.navAppointments),
              ),
              NavigationDrawerDestination(
                icon: const Icon(Icons.person_outline_rounded),
                selectedIcon: const Icon(Icons.person_rounded),
                label: Text(l10n.navProfile),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: AppBackgroundPattern(child: shell),
          ),
        ],
      ),
    );
  }
}
