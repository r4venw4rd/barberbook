import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_background_pattern.dart';
import 'package:hair_dryer_app/src/core/presentation/floating_glass_nav_bar.dart';
import 'package:hair_dryer_app/src/core/presentation/nav_bar_observer.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Mobile shell with floating glass navigation.
class MobileAppShell extends StatelessWidget {
  const new({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final bottomOffset = MediaQuery.paddingOf(context).bottom + 10;
    final destinations = [
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home_rounded),
        label: l10n.navHome,
      ),
      NavigationDestination(
        icon: const Icon(Icons.event_note_outlined),
        selectedIcon: const Icon(Icons.event_note_rounded),
        label: l10n.navAppointments,
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline_rounded),
        selectedIcon: const Icon(Icons.person_rounded),
        label: l10n.navProfile,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          AppBackgroundPattern(child: shell),
          ValueListenableBuilder<bool>(
            valueListenable: navBarObserver.isNavBarVisible,
            builder: (context, isVisible, _) => AnimatedPositioned(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 320),
              curve: isVisible ? Curves.easeOutBack : Curves.easeInCubic,
              left: 20,
              right: 20,
              bottom: isVisible ? bottomOffset : -(64 + bottomOffset + 12),
              height: 64,
              child: AnimatedOpacity(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 200),
                opacity: isVisible ? 1 : 0,
                child: FloatingGlassNavBar(
                  selectedIndex: shell.currentIndex,
                  destinations: destinations,
                  reduceMotion: reduceMotion,
                  onDestinationSelected: (index) => shell.goBranch(
                    index,
                    initialLocation: index == shell.currentIndex,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
