import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Primary action button with modern depth: a brand gradient fill, a glossy
/// sheen, a soft coloured glow underneath and a press-in scale.
///
/// Colours come from [AppColors] tokens only, so the palette never changes
/// between light and dark themes.
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

  /// Called on tap; `null` renders the button disabled and dimmed.
  final VoidCallback? onPressed;

  /// Content of the button, usually a [Text] label.
  final Widget child;

  /// Overrides the palette fill gradient.
  final Gradient? gradient;

  /// Overrides the label and ripple colour.
  final Color? foregroundColor;

  /// Overrides the coloured glow.
  final Color? shadowColor;

  /// Overrides the default content padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final pressed = useState(false);
    final enabled = onPressed != null;
    final active = pressed.value && enabled;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final isDark = context.isDarkTheme;
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(AppRadius.lg);

    final fill =
        gradient ??
        (isDark ? AppColors.darkPrimaryGradient : AppColors.primaryGradient);
    final glow =
        shadowColor ??
        (isDark ? AppColors.darkShadowPrimary : AppColors.shadowPrimary);
    final foreground = foregroundColor ?? theme.colorScheme.onPrimary;

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
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: AppColors.buttonSheenGradient,
                    borderRadius: radius,
                  ),
                  child: InkWell(
                    onTap: enabled
                        ? () {
                            unawaited(HapticFeedback.lightImpact());
                            onPressed?.call();
                          }
                        : null,
                    onHighlightChanged: (value) => pressed.value = value,
                    borderRadius: radius,
                    highlightColor: foreground.withValues(alpha: 0.18),
                    splashColor: foreground.withValues(alpha: 0.10),
                    child: Padding(
                      padding:
                          padding ??
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
