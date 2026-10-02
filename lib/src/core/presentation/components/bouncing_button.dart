import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A wrapper that adds a subtle physical bounce (scale-down to 0.96)
/// and crisp haptic feedback when pressed.
class BouncingWrapper extends StatefulWidget {
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
  State<BouncingWrapper> createState() => _BouncingWrapperState();
}

class _BouncingWrapperState extends State<BouncingWrapper> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) {
    if (widget.onTap == null) return;
    setState(() => _isPressed = true);
    if (widget.enableHaptics) {
      unawaited(HapticFeedback.lightImpact());
    }
  }

  void _onTapUp(TapUpDetails _) {
    if (_isPressed) setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    if (_isPressed) setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: (!reduceMotion && _isPressed) ? widget.scaleDown : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
