import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_gradients.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Primary action button with depth: brand gradient, glow and press scale.
class PrimaryButton extends HookWidget {
  const new({
    required this.onPressed,
    required this.child,
    super.key,
    this.gradient,
    this.foregroundColor,
    this.shadowColor,
    this.padding,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Gradient? gradient;
  final Color? foregroundColor;
  final Color? shadowColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final pressed = useState(false);
    final enabled = onPressed != null;
    final active = pressed.value && enabled;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(AppRadius.lg);
    final fill = gradient ?? context.primaryGradient;
    final glow = shadowColor ?? context.primaryShadow;
    final foreground = foregroundColor ?? AppColors.onPrimary;

    return Semantics(
      button: true,
      enabled: enabled,
      excludeSemantics: true,
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0.45,
        duration: const Duration(milliseconds: 140),
        child: AnimatedScale(
          scale: active && !reduceMotion ? 0.97 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            constraints: const BoxConstraints(
              minWidth: 64,
              minHeight: kTouchTarget,
            ),
            decoration: BoxDecoration(
              gradient: fill,
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: glow,
                  offset: Offset(0, active ? 3 : 7),
                  blurRadius: active ? 10 : 18,
                  spreadRadius: active ? -4 : -2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: Material(
                color: AppColors.clear,
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: AppGradients.buttonSheenGradient,
                  ),
                  child: InkWell(
                    onTap: enabled
                        ? () {
                            unawaited(HapticFeedback.lightImpact());
                            onPressed?.call();
                          }
                        : null,
                    onHighlightChanged: (v) => pressed.value = v,
                    highlightColor: foreground.withValues(alpha: 0.18),
                    splashColor: foreground.withValues(alpha: 0.10),
                    child: Padding(
                      padding: padding ??
                          const EdgeInsets.symmetric(
                            horizontal: AppSpace.xl,
                            vertical: AppSpace.md,
                          ),
                      child: Center(
                        child: IconTheme.merge(
                          data: IconThemeData(color: foreground),
                          child: DefaultTextStyle.merge(
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.1,
                              color: foreground,
                            ),
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
