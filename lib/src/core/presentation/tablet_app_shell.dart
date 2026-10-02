import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_background_pattern.dart';

/// Tablet shell with a compact navigation rail.
class TabletAppShell extends StatelessWidget {
  const new({required this.shell, super.key});

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
          Expanded(child: AppBackgroundPattern(child: shell)),
        ],
      ),
    );
  }
}
