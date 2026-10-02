import 'package:flutter/material.dart';

/// Tracks whether a modal/popup route (bottom sheet, dialog, etc.) is
/// currently overlaid on top of the navigator. Exposes this via
/// [isNavBarVisible] — a [ValueNotifier] that the floating nav bar listens to.
///
/// Register this observer with [GoRouter] (or any [Navigator]) via
/// `observers: [navBarObserver]`.
class NavBarObserver extends NavigatorObserver {
  /// Whether the floating nav bar should be visible.
  ///
  /// `true`  → no modal on top — show nav bar
  /// `false` → a modal (PopupRoute) is on top — hide nav bar
  final ValueNotifier<bool> isNavBarVisible = ValueNotifier(true);

  // Counts nested modal layers so we only restore visibility when the last
  // modal is popped (handles stacked dialogs / confirm dialogs over sheets).
  int _modalDepth = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PopupRoute) {
      _modalDepth++;
      isNavBarVisible.value = false;
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PopupRoute) {
      _modalDepth = (_modalDepth - 1).clamp(0, 999);
      if (_modalDepth == 0) {
        isNavBarVisible.value = true;
      }
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PopupRoute) {
      _modalDepth = (_modalDepth - 1).clamp(0, 999);
      if (_modalDepth == 0) {
        isNavBarVisible.value = true;
      }
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    // If a popup was replaced by a non-popup, restore visibility
    if (oldRoute is PopupRoute && newRoute is! PopupRoute) {
      _modalDepth = (_modalDepth - 1).clamp(0, 999);
      if (_modalDepth == 0) {
        isNavBarVisible.value = true;
      }
    }
  }

  /// Convenience disposal — call if you ever need to clean up.
  void dispose() => isNavBarVisible.dispose();
}

/// Singleton observer instance shared between the router and the nav bar.
final navBarObserver = NavBarObserver();
