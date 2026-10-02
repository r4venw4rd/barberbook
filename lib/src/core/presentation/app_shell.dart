import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/presentation/desktop_app_shell.dart';
import 'package:hair_dryer_app/src/core/presentation/mobile_app_shell.dart';
import 'package:hair_dryer_app/src/core/presentation/tablet_app_shell.dart';
import 'package:hair_dryer_app/src/core/theme/breakpoints.dart';

/// Responsive navigation shell for the app's primary destinations.
class AppShell extends StatelessWidget {
  const new({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) return DesktopAppShell(shell: shell);
    if (context.isTablet) return TabletAppShell(shell: shell);
    return MobileAppShell(shell: shell);
  }
}
