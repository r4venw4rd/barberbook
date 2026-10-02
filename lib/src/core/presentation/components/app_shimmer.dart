import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// A lightweight, premium shimmering container that creates a smooth sweep
/// animation across all nested [ShimmerBox] elements.
class AppShimmer extends StatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final isDark = context.isDarkTheme;

    final baseColor = isDark
        ? AppColors.darkCardElevated
        : const Color(0xFFE8EAEF);
    final highlightColor = isDark
        ? const Color(0xFF282C38)
        : const Color(0xFFF6F7F9);

    if (reduceMotion) {
      return _ShimmerScope(
        baseColor: baseColor,
        highlightColor: highlightColor,
        progress: 0.5,
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return _ShimmerScope(
          baseColor: baseColor,
          highlightColor: highlightColor,
          progress: _controller.value,
          child: child!,
        );
      },
      child: widget.child,
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
    final isDark = context.isDarkTheme;

    final baseColor = scope?.baseColor ??
        (isDark ? AppColors.darkCardElevated : const Color(0xFFE8EAEF));
    final highlightColor = scope?.highlightColor ??
        (isDark ? const Color(0xFF282C38) : const Color(0xFFF6F7F9));
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
          colors: [
            baseColor,
            highlightColor,
            baseColor,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pre-built Domain Skeleton Components
// ---------------------------------------------------------------------------

/// Horizontal service scroller placeholder.
class ServiceScrollerSkeleton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SizedBox(
        height: 158,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpace.md),
          itemBuilder: (context, _) => const SizedBox(
            width: 160,
            child: SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: 46,
                    height: 46,
                    radius: AppRadius.md + 2,
                  ),
                  Spacer(),
                  ShimmerBox(width: 100, height: 16),
                  SizedBox(height: 6),
                  ShimmerBox(width: 70, height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal barber scroller placeholder.
class BarberScrollerSkeleton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SizedBox(
        height: 186,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpace.md),
          itemBuilder: (context, _) => const SizedBox(
            width: 176,
            child: SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ShimmerBox(
                      width: 58,
                      height: 58,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: AppSpace.sm + 4),
                  ShimmerBox(width: 90, height: 14),
                  SizedBox(height: 6),
                  ShimmerBox(width: 130, height: 11),
                  Spacer(),
                  Row(
                    children: [
                      ShimmerBox(width: 44, height: 18, radius: AppRadius.sm),
                      Spacer(),
                      ShimmerBox(width: 50, height: 18, radius: AppRadius.pill),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Vertical service tile list skeleton for service booking page.
class BookingServiceSkeleton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.sm,
        ),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpace.md),
        itemBuilder: (context, _) => const SoftCard(
          radius: AppRadius.lg,
          child: Row(
            children: [
              ShimmerBox(
                width: 44,
                height: 44,
              ),
              SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 120, height: 16),
                    SizedBox(height: 6),
                    ShimmerBox(width: 180, height: 12),
                  ],
                ),
              ),
              SizedBox(width: AppSpace.md),
              ShimmerBox(width: 45, height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vertical barber tile list skeleton for barber booking page.
class BookingBarberSkeleton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.sm,
        ),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpace.md),
        itemBuilder: (context, _) => const SoftCard(
          radius: AppRadius.lg,
          child: Row(
            children: [
              ShimmerBox(
                width: 52,
                height: 52,
                shape: BoxShape.circle,
              ),
              SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 110, height: 16),
                    SizedBox(height: 6),
                    ShimmerBox(width: 150, height: 12),
                  ],
                ),
              ),
              SizedBox(width: AppSpace.md),
              ShimmerBox(width: 48, height: 22, radius: AppRadius.sm),
            ],
          ),
        ),
      ),
    );
  }
}
