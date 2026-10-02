import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// A lightweight, premium shimmering container that creates a smooth sweep
/// animation across all nested [ShimmerBox] elements.
class AppShimmer extends HookWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final baseColor = context.shimmerBase;
    final highlightColor = context.shimmerHighlight;

    if (reduceMotion) {
      return _ShimmerScope(
        baseColor: baseColor,
        highlightColor: highlightColor,
        progress: 0.5,
        child: child,
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return _ShimmerScope(
          baseColor: baseColor,
          highlightColor: highlightColor,
          progress: controller.value,
          child: child!,
        );
      },
      child: child,
    );
  }
}

class _ShimmerScope extends InheritedWidget {
  const new({
    required this.baseColor,
    required this.highlightColor,
    required this.progress,
    required super.child,
  });

  final Color baseColor;
  final Color highlightColor;
  final double progress;

  static _ShimmerScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ShimmerScope>();

  @override
  bool updateShouldNotify(_ShimmerScope oldWidget) =>
      oldWidget.progress != progress ||
      oldWidget.baseColor != baseColor ||
      oldWidget.highlightColor != highlightColor;
}

/// A placeholder box that renders the ambient shimmer gradient.
class ShimmerBox extends StatelessWidget {
  const new({
    super.key,
    this.width,
    this.height,
    this.radius = AppRadius.md,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double? height;
  final double radius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final scope = _ShimmerScope.of(context);
    final baseColor = scope?.baseColor ?? context.shimmerBase;
    final highlightColor = scope?.highlightColor ?? context.shimmerHighlight;
    final progress = scope?.progress ?? 0.0;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(radius)
            : null,
        gradient: LinearGradient(
          begin: Alignment(-2.0 + (4.0 * progress), 0),
          end: Alignment(-0.5 + (4.0 * progress), 0),
          colors: [baseColor, highlightColor, baseColor],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
