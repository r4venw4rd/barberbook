import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Soft, elevated card surface with a premium multi-layer shadow system.
class SoftCard extends HookWidget {
  /// Creates a soft card.
  const new({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpace.lg),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.color,
    this.borderColor,
    this.radius = AppRadius.xl,
  });

  /// Card content.
  final Widget child;

  /// Inner padding around [child].
  final EdgeInsetsGeometry padding;

  /// Outer margin around the card surface.
  final EdgeInsetsGeometry margin;

  /// Makes the whole card tappable when provided.
  final VoidCallback? onTap;

  /// Overrides the themed card surface colour.
  final Color? color;

  /// Overrides the themed card border colour.
  final Color? borderColor;

  /// Corner radius of the card.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isPressed = useState(false);
    final isDark = context.isDarkTheme;
    final background = color ?? context.cardSurface;
    final border = borderColor ?? context.borderSurface;

    return AnimatedScale(
      scale: isPressed.value ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        margin: margin,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isPressed.value && onTap != null
                ? border.withValues(alpha: isDark ? 0.6 : 0.8)
                : border,
          ),
          boxShadow: isDark
              ? null
              : isPressed.value
              ? [
                  const BoxShadow(
                    color: AppColors.shadowCard,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : [
                  const BoxShadow(
                    color: AppColors.shadowCard,
                    blurRadius: 12,
                    spreadRadius: -1,
                    offset: Offset(0, 4),
                  ),
                  const BoxShadow(
                    color: AppColors.shadowCardDeep,
                    blurRadius: 24,
                    spreadRadius: -4,
                    offset: Offset(0, 10),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - 1),
          child: Material(
            color: AppColors.clear,
            child: onTap == null
                ? Padding(padding: padding, child: child)
                : InkWell(
                    onTap: onTap,
                    onTapDown: (_) {
                      isPressed.value = true;
                      unawaited(HapticFeedback.selectionClick());
                    },
                    onTapUp: (_) => isPressed.value = false,
                    onTapCancel: () => isPressed.value = false,
                    child: Padding(padding: padding, child: child),
                  ),
          ),
        ),
      ),
    );
  }
}
