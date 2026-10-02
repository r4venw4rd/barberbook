import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A wrapper that adds a subtle physical bounce (scale-down to 0.96)
/// and crisp haptic feedback when pressed.
class BouncingWrapper extends HookWidget {
  const new({
    required this.child,
    super.key,
    this.onTap,
    this.scaleDown = 0.96,
    this.enableHaptics = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final bool enableHaptics;

  @override
  Widget build(BuildContext context) {
    final isPressed = useState(false);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    void onTapDown(TapDownDetails _) {
      if (onTap == null) return;
      isPressed.value = true;
      if (enableHaptics) {
        unawaited(HapticFeedback.lightImpact());
      }
    }

    void onTapUp(TapUpDetails _) {
      if (isPressed.value) isPressed.value = false;
    }

    void onTapCancel() {
      if (isPressed.value) isPressed.value = false;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onTap: onTap,
      child: AnimatedScale(
        scale: (!reduceMotion && isPressed.value) ? scaleDown : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: child,
      ),
    );
  }
}
